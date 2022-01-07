$(function () {

	function display(bool){
		if (bool) {
			$('body').show();
			$('.contenttt').show();
			$('.vehiclemenu').hide();
			$('.armemenu').hide();
			$('body').addClass("active");
		} else {
			$('body').hide();
			$('.vehiclemenu').hide();
			$('.armemenu').hide();
			$('body').removeClass("active");
		}
	}
	window.addEventListener('message', function (event) {
		var item = event.data;
		if (item.type === "ui") {
			if (item.status == true){
				display(true)
			} else {
				display(false)
			}
		} else if (item.type === "point") {
			$('.displaycoin').html("Vous avez : "+ item.coin +" coins");
		}
	});

	document.onkeyup = function (data) {
		if (data.which == 27) {
			$.post("http://louiskle_tebex_html/NUIFocusOff", JSON.stringify({}))
		}
	}
});
$('.btn-sign-out').click(function (){
	$('body').hide();
	$('body').removeClass("active");
	$.post('http://louiskle_tebex_html/NUIFocusOff', JSON.stringify({}));
})

function g_lk_tebex_buy(type, item) {
	$('body').hide();
	$('body').removeClass("active");
	$.post('http://louiskle_tebex_html/addbyitem', JSON.stringify({type: type, item:item}));
	$.post('http://louiskle_tebex_html/NUIFocusOff', JSON.stringify({}));
}


function vehicle_menu_active() {
	$('.contenttt').hide();
	$('.vehiclemenu').show();
}

function arme_menu_active() {
	$('.contenttt').hide();
	$('.armemenu').show();
}
