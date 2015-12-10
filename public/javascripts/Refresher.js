function Refresher() {
    var selectedSimulation;
    var drawer;
    var that = this;

    function loadAllSimulationsAjax() {
        $.getJSON('/all_simulations/', function(data) {
            loadAllSimulations(data);
        });
    }

    function loadAllSimulations(data) {
        var panel = document.querySelector('#all_simulations [name=content]');
        panel.innerHTML = '';
        data.forEach(function(value, key) {
            var row = document.createElement('div');
            row.setAttribute('name', value);
            row.innerHTML = value;
            $(row).click(function() {
                loadAllSlidesAjax(value);
            });
            panel.appendChild(row);
        });
    }


    function loadAllSlidesAjax(name) {
        selectedSimulation = name;
        $('#all_simulations [name=content] div').removeClass('selected');
        $('#all_simulations [name=content] div[name='+name+']').addClass('selected');

        $.getJSON('/all_slides/'+name, function(data) {
            loadAllSlides(data);
        });
    }

    function loadAllSlides(data) {
        var panel = document.querySelector('#all_slides [name=content]');
        panel.innerHTML = '';
        data.forEach(function(value, key) {
            var row = document.createElement('div');
            row.setAttribute('name', value);
            row.innerHTML = value;
            //$(row).click(function() {
                //loadAllSlidesAjax(value);
            //});
            panel.appendChild(row);
        });
    }

    function loadSlideAjax(simulation, ajax) {
        $.getJSON('evolution_output/2015-12-10_00-25-50_3ycePYfc/0.json', function(data) {
            drawAll(data);
        });
    }

    function setDrawer(value) {
        drawer = value;
        return that;
    }

    function loadListeners() {
        $('#all_simulations button').click(loadAllSimulationsAjax);
    }

    function init() {
        loadListeners();
        loadAllSimulationsAjax();
    }

    this.setDrawer = setDrawer;
    this.init = init;
}
