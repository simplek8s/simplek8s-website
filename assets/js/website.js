/*!
 * Color mode toggler for Bootstrap's docs (https://getbootstrap.com/)
 * Copyright 2011-2023 The Bootstrap Authors
 * Licensed under the Creative Commons Attribution 3.0 Unported License.
 */

(() => {
  "use strict";

  const getTheme = () => {
    const storedTheme = localStorage.getItem("theme");
    if (["light", "dark"].indexOf(storedTheme) > -1) {
      return storedTheme;
    }

    return window.matchMedia("(prefers-color-scheme: dark)").matches
      ? "dark"
      : "light";
  };

  const setTheme = (theme) => {
    document.documentElement.setAttribute("data-bs-theme", theme);
    localStorage.setItem("theme", theme);
  };

  window
    .matchMedia("(prefers-color-scheme: dark)")
    .addEventListener("change", () => {
      const theme = getTheme();
      setTheme(theme);
    });

  const setToggleTheme = () => {
    var theme = getTheme() === "light" ? "dark" : "light";
    setTheme(theme);
  };

  window.addEventListener("DOMContentLoaded", () => {
    Array.from(document.getElementsByClassName("btnToggleTheme")).forEach(
      (toggle) => {
        toggle.addEventListener("click", setToggleTheme);
      },
    );
  });
})();
