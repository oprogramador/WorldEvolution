function Toggle() {
  $('[toggle_mode=long]').hide();
  $('[toggle_mode=short]').click(function() {
      $('[toggle_mode=long][name='+this.getAttribute('name')+']').toggle();
  });
}
