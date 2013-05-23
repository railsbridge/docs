$(document).ready(function(){
	$.facebox.settings.closeImage = "/img/facebox_closelabel.png";
	$.facebox.settings.loadingImage = "/img/facebox_loading.gif";
	$("a[rel*=facebox]").facebox();
})

