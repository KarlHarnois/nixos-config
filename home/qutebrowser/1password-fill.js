const qute1pass = {
  fill(encodedUrl, encodedUsername, encodedPassword) {
    if (window.location.href !== this.decode(encodedUrl)) {
      alert("1Password: the page changed before filling, nothing was filled.");
      return;
    }
    const inputs = this.visibleInputs();
    this.fillAll(this.usernameInputs(inputs), this.decode(encodedUsername));
    this.fillAll(inputs.filter((input) => input.type === "password"), this.decode(encodedPassword));
  },

  decode(encoded) {
    const bytes = Uint8Array.from(atob(encoded), (character) => character.charCodeAt(0));
    return new TextDecoder().decode(bytes);
  },

  visibleInputs() {
    return [...document.querySelectorAll("input")].filter(
      (input) => input.getClientRects().length > 0 && getComputedStyle(input).visibility === "visible",
    );
  },

  usernameInputs(inputs) {
    const usernameHint = /user|email|login/i;
    return inputs.filter(
      (input) =>
        input.type === "email" ||
        input.autocomplete.includes("username") ||
        (input.type === "text" && usernameHint.test(input.name + input.id)),
    );
  },

  fillAll(inputs, value) {
    if (value === "") return;
    inputs.forEach((input) => this.fillInput(input, value));
  },

  fillInput(input, value) {
    const nativeValueSetter = Object.getOwnPropertyDescriptor(HTMLInputElement.prototype, "value").set;
    nativeValueSetter.call(input, value);
    input.dispatchEvent(new Event("input", { bubbles: true }));
    input.dispatchEvent(new Event("change", { bubbles: true }));
  },
};
