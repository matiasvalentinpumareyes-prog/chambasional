/** @type {import('tailwindcss').Config} */
export default {
  content: ["./index.html", "./src/**/*.{js,ts,jsx,tsx}"],
  theme: {
    extend: {
      colors: {
        bg: "#F6F7F3",
        surface: "#FFFFFF",
        ink: "#14201C",
        muted: "#5B6660",
        border: "#E1E4DC",
        brand: {
          DEFAULT: "#1F6F5C",
          dark: "#164F42",
          light: "#E6F0EC",
        },
        urgent: {
          DEFAULT: "#E7A33E",
          dark: "#B87A1F",
          light: "#FCF0DA",
        },
        risk: {
          low: "#3C8361",
          medium: "#C79A2A",
          high: "#D97706",
          critical: "#B5442E",
        },
        success: {
          DEFAULT: "#3C8361",
          light: "#E4F1EA",
        },
      },
      fontFamily: {
        display: ["Space Grotesk", "sans-serif"],
        body: ["IBM Plex Sans", "sans-serif"],
      },
      borderRadius: {
        DEFAULT: "6px",
      },
      boxShadow: {
        panel: "0 1px 2px rgba(20, 32, 28, 0.04)",
        popover: "0 8px 24px rgba(20, 32, 28, 0.12)",
      },
    },
  },
  plugins: [],
};
