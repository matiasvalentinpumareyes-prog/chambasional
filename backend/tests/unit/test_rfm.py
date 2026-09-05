from datetime import datetime, timedelta, timezone

from app.models.customer import ActivityStatus, Customer, CustomerSegment
from app.services.rfm import compute_activity_status, compute_rfm_for_customer, segment_from_rfm


def _make_customer(**overrides) -> Customer:
    defaults = dict(
        business_id="biz1", first_name="Test", last_name="Customer",
        registered_at=datetime.now(timezone.utc) - timedelta(days=200),
        purchase_count=5, total_spend=500.0, avg_interval_days=30,
        last_purchase_at=datetime.now(timezone.utc) - timedelta(days=10),
    )
    defaults.update(overrides)
    return Customer(**defaults)


def test_rfm_recency_uses_days_since_last_purchase():
    now = datetime.now(timezone.utc)
    customer = _make_customer(last_purchase_at=now - timedelta(days=15))
    rfm = compute_rfm_for_customer(customer, now)
    assert rfm["recency_days"] == 15


def test_rfm_recency_is_9999_when_no_purchases():
    now = datetime.now(timezone.utc)
    customer = _make_customer(last_purchase_at=None, purchase_count=0, total_spend=0)
    rfm = compute_rfm_for_customer(customer, now)
    assert rfm["recency_days"] == 9999


def test_segment_new_for_recent_customer_with_few_purchases():
    rfm = {"r": 5, "f": 1, "m": 1}
    segment = segment_from_rfm(rfm, purchase_count=1, registered_days_ago=5)
    assert segment == CustomerSegment.new


def test_segment_vip_for_high_rfm():
    rfm = {"r": 5, "f": 5, "m": 5}
    segment = segment_from_rfm(rfm, purchase_count=20, registered_days_ago=300)
    assert segment == CustomerSegment.vip


def test_segment_lost_for_low_recency_and_frequency():
    rfm = {"r": 1, "f": 1, "m": 2}
    segment = segment_from_rfm(rfm, purchase_count=3, registered_days_ago=300)
    assert segment == CustomerSegment.lost


def test_activity_status_uses_individual_interval_not_fixed_threshold():
    """
    Sección 12 del brief: un cliente que compra cada 7 días y lleva 20
    sin comprar debe verse en más riesgo que uno que compra cada 180 días
    y lleva 100 sin comprar — NUNCA una regla fija tipo "30 días = perdido".
    """
    now = datetime.now(timezone.utc)

    frequent_buyer = _make_customer(avg_interval_days=7, last_purchase_at=now - timedelta(days=20))
    rfm_frequent = compute_rfm_for_customer(frequent_buyer, now)
    status_frequent = compute_activity_status(frequent_buyer, rfm_frequent)

    infrequent_buyer = _make_customer(avg_interval_days=180, last_purchase_at=now - timedelta(days=100))
    rfm_infrequent = compute_rfm_for_customer(infrequent_buyer, now)
    status_infrequent = compute_activity_status(infrequent_buyer, rfm_infrequent)

    assert status_frequent in (ActivityStatus.at_risk, ActivityStatus.dormant, ActivityStatus.lost)
    assert status_infrequent == ActivityStatus.active


def test_activity_status_cold_start_with_single_purchase():
    now = datetime.now(timezone.utc)
    customer = _make_customer(purchase_count=1, avg_interval_days=None, last_purchase_at=now - timedelta(days=100))
    rfm = compute_rfm_for_customer(customer, now)
    status = compute_activity_status(customer, rfm)
    assert status == ActivityStatus.lost  # regla conservadora de cold start: >90 días sin comprar
