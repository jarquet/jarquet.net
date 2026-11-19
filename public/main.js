// Progressive enhancement only; the page works without JavaScript.
// Shows a "Copy" button next to the email address when the Clipboard API is available.
(function () {
  if (!navigator.clipboard || !window.isSecureContext) return;
  document.querySelectorAll("button.copy[data-copy]").forEach(function (btn) {
    btn.hidden = false;
    btn.addEventListener("click", function () {
      navigator.clipboard.writeText(btn.dataset.copy).then(function () {
        btn.textContent = "Copied";
        setTimeout(function () { btn.textContent = "Copy"; }, 1800);
      });
    });
  });
})();
