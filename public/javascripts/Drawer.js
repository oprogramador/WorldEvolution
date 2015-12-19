function Drawer() {
    var simulationData;

    function drawAll(data) {
        simulationData = data;
        countAnimals(data)
        drawFields(data);
    }

    function countAnimals(data) {
        data.animals.forEach(function(animal, key) {
            var field = data.fields[animal.position.y - 1][animal.position.x - 1];
            if(typeof field.animals === 'undefined') field.animals = [];
            field.animals.push(animal);
            if(typeof field.count === 'undefined') field.count = 0;
            field.count++;
        });
    }

    function drawFields(data) {
        var table = document.createElement('table');
        table.setAttribute('border', 2);
        var board = document.getElementById('board');
        board.innerHTML = '';
        board.appendChild(table);
        data.fields.forEach(function(row, y) {
            var tr = document.createElement('tr');
            table.appendChild(tr);
            row.forEach(function(cell, x) {
                var td = document.createElement('td');
                $(td).click(function() {
                    showFieldStatus(x, y);   
                });
                td.style.backgroundColor = 'rgb('+Math.floor(cell.temperature)+','+Math.floor(cell.food)+',0)';
                td.style.color = 'white';
                td.style.width = 32;
                td.style.height = 32;
                if(typeof cell.count !== 'undefined') td.innerHTML = cell.count;
                tr.appendChild(td);
            });
        });
    }

    function showProperties(element, object) {
        var ul = document.createElement('ul');
        element.appendChild(ul);
        var keys = Object.keys(object);
        for(var i = 0; i < keys.length; i++) {
            var key = keys[i];
            var value = object[key];
            var li = document.createElement('li');
            ul.appendChild(li);
            if(typeof value !== 'object') li.innerHTML = key+': '+value;
            else {
                li.innerHTML = key+':'
                showProperties(li, value);
            }
        }
    }

    function showFieldStatus(x, y) {
        var dialodDiv = document.createElement('div');
        dialodDiv.style.display = 'none';
        showProperties(dialodDiv, simulationData.fields[y][x]);
        $('body').append(dialodDiv);
        $(dialodDiv).dialog({
            title: '('+x+', '+y+')',
            width: 600
        });
    }

    this.drawAll = drawAll;
}
