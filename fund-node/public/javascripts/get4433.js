var selection=[];

	function selectRow(x) {
		x.style.backgroundColor=(x.style.backgroundColor=='black')?(''):('black');
    	x.style.color=(x.style.color=='white')?('black'):('white');

    	if (selection.indexOf(x.id) > -1) {
    		selection.splice(selection.indexOf(x.id), 1);
    		//alert("drop!");
    	}
    	else{
    		selection.push(x.id);
    		//alert("pushed!");
    	}
    	

    	if (x.classList == 'selected') {
    		x.classList ='';
    	}
    	else{
    		x.classList.add('selected');
    	}
	}

	function selectAll(){
		var data_table = document.getElementById("dataTable");   
    	var data_rows = data_table.getElementsByTagName("tr");   

    	if (document.getElementById("selectAll").checked) {
    		selection.length=0;

    		for (var i = 1; i<data_rows.length; i++) {
				data_rows[i].style.backgroundColor = 'black';
				data_rows[i].style.color='white';
				data_rows[i].className=('selected');

				selection.push(data_rows[i].id);
			}
    	}
    	else{
    		for (var i = 0; i<data_rows.length; i++) {
				data_rows[i].style.backgroundColor = '';
				data_rows[i].style.color='black';
				data_rows[i].className=('');
			}
			selection.length=0;
    	}

	}

	function submitFund(){
		if(selection.length==0){
		alert("請至少選擇一筆基金");
		}
		else{
		var json_name = {"id_array":selection,"user":"admin"};
		var json_Selection = JSON.stringify(json_name);
		document.getElementById("portfolioSelection").value=json_Selection;
		//alert(document.getElementById("portfolioSelection").value);
		document.getElementById('postData').submit();
		}
	}
	
