(function() {
    new Toggle();
    var drawer = new Drawer();
    var refresher = new Refresher();
    refresher.setDrawer(drawer);
    refresher.init();
    var generator = new Generator();
})();
