window.GOVUK = window.GOVUK || {}
window.GOVUK.Modules = window.GOVUK.Modules || {};

(function (Modules) {
  function ShowPassword () { }

  ShowPassword.prototype.start = function ($module) {
    this.$module = $module[0]
    this.input = this.$module.querySelector('.gem-c-input')
    this.$module.togglePassword = this.togglePassword.bind(this)
    this.$module.revertToPasswordOnFormSubmit = this.revertToPasswordOnFormSubmit.bind(this)
    this.input.classList.add('gem-c-input--with-password')

    this.showPasswordText = this.$module.getAttribute('data-show')
    this.hidePasswordText = this.$module.getAttribute('data-hide')
    this.shownPassword = this.$module.getAttribute('data-announce-show')
    this.hiddenPassword = this.$module.getAttribute('data-announce-hide')

    // wrap the input in a new div
    this.wrapper = document.createElement('div')
    this.wrapper.classList.add('gem-c-show-password__input-wrapper')
    this.input.parentNode.insertBefore(this.wrapper, this.input)
    this.wrapper.appendChild(this.input)

    // create and append the button
    this.showHide = document.createElement('button')
    this.showHide.className = 'gem-c-show-password__toggle'
    this.showHide.setAttribute('aria-controls', this.input.getAttribute('id'))
    this.showHide.setAttribute('type', 'button')
    this.showHide.innerHTML = this.showPasswordText
    this.wrapper.insertBefore(this.showHide, this.input.nextSibling)

    // create and append the status text for screen readers
    this.statusText = document.createElement('span')
    this.statusText.classList.add('govuk-visually-hidden')
    this.statusText.innerHTML = this.hiddenPassword
    this.statusText.setAttribute('aria-live', 'polite')
    this.wrapper.insertBefore(this.statusText, this.showHide.nextSibling)

    this.showHide.addEventListener('click', this.$module.togglePassword)

    this.parentForm = this.input.form
    var disableFormSubmitCheck = this.$module.getAttribute('data-disable-form-submit-check')

    if (this.parentForm && !disableFormSubmitCheck) {
      this.parentForm.addEventListener('submit', this.$module.revertToPasswordOnFormSubmit)
    }
  }

  ShowPassword.prototype.togglePassword = function (event) {
    event.preventDefault()
    this.showHide.innerHTML = this.showHide.innerHTML === this.showPasswordText ? this.hidePasswordText : this.showPasswordText
    this.statusText.innerHTML = this.statusText.innerHTML === this.shownPassword ? this.hiddenPassword : this.shownPassword
    this.input.setAttribute('type', this.input.getAttribute('type') === 'text' ? 'password' : 'text')
  }

  ShowPassword.prototype.revertToPasswordOnFormSubmit = function (event) {
    this.showHide.innerHTML = this.showPasswordText
    this.statusText.innerHTML = this.hiddenPassword
    this.input.setAttribute('type', 'password')
  }

  Modules.ShowPassword = ShowPassword
})(window.GOVUK.Modules)
