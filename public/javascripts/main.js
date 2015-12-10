$.getJSON('evolution_output/2015-12-10_00-25-50_3ycePYfc/0.json', function(data) {
    drawAll(data);
});

function drawAll(data) {
    countAnimals(data)
    drawFields(data);
}

function countAnimals(data) {
    data.animals.forEach(function(animal, key) {
        console.log(data);
        console.log(animal.position);
        var field = data.fields[animal.position.y - 1][animal.position.x - 1];
        if(typeof field.count === 'undefined') field.count = 0;
        field.count++;
    });
}

function drawFields(data) {
    var table = document.createElement('table');
    table.setAttribute('border', 2);
    document.getElementById('board').appendChild(table);
    data.fields.forEach(function(row, y) {
        var tr = document.createElement('tr');
        table.appendChild(tr);
        row.forEach(function(cell, x) {
            var td = document.createElement('td');
            td.style.backgroundColor = 'rgb('+Math.floor(cell.temperature)+','+Math.floor(cell.food)+',0)';
            td.style.color = 'white';
            td.style.width = 32;
            td.style.height = 32;
            if(typeof cell.count !== 'undefined') td.innerHTML = cell.count;
            tr.appendChild(td);
            console.log(cell);
        });
    });
}

function drawAnimals(animals) {
}
