var Dashboard = {
  tinyURLList: $('table tbody'),

  init: function() {
    this._bindTinyURLFormSubmission();
  },

  _bindTinyURLFormSubmission: function() {
    var _this = this,
        $form = $('#new_tiny_url');

    $form.on('ajax:success', function(event, data, textStatus, jqXHR) {
      _this.tinyURLList.prepend(data);
      $form.find('input[type=text]').val('').end().find('.error-msg').remove();
    }).on('ajax:error', function(event, jqXHR, textStatus, error) {
      $form.replaceWith(jqXHR.responseText)
      _this._bindTinyURLFormSubmission();
    })
  }
}
