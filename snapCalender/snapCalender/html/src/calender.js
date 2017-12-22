var	$year = $('#js_year'),
	$month = $('#js_month'),
	$tbody = $('#js_calendar_body');

var today = new Date();

var	currentYear  = today.getFullYear(),
	currentMonth = today.getMonth() + 1;

var $displayYear  = currentYear,
	$displayMonth = currentMonth;



/* Default */
$(document).on('ready', function() {
	calendarHeading($displayYear, $displayMonth);
	calendarBody($displayYear, $displayMonth);
});

function calendarBody(year, month) {

	// その月の最初の日の情報
	var startDate = new Date(year, month-1, 1);

	// その月の最後の日の情報
	var endDate  = new Date(year, month, 0);

	// その月の最初の日の曜日を取得
	var startDay = startDate.getDay();

	// その月の最後の日の曜日を取得
	var endDay = endDate.getDate();

	// 日にちを埋める用のフラグ
	var textSkip = true;

	// 日付(これがカウントアップされます)
	var textDate = 1;

	// テーブルのHTMLを格納する変数
	var tableBody ='';

	for (var row = 0; row < 6; row++){
		var tr = '<tr>';
		for (var col = 0; col < 7; col++) {
			if (row === 0 && startDay === col){
				textSkip = false;
			}
			if (textDate > endDay) {
				textSkip = true;
			}
			var textTd = textSkip ? '&nbsp;' : textDate++;
			var td = '<td class="calender__td" data-day="' + textTd + '"><span class="calender__td_text js_cell">' + textTd + '</span></td>';
			tr += td;
		}
		tr += '</tr>';
		tableBody += tr;
	}
	$tbody.html(tableBody);
}

function calendarHeading(year, month) {
	$year.html('<span data-year="' + year + '">' + year + '</span>');
	$month.html('<span data-month="' + month + '">' + month + '</span>');
}

/* Next */
$(document).on('tap', '#js_next', function() {
	$displayMonth++;
	if($displayMonth > 12) {
		$displayYear++;
		$displayMonth = 1;
	}
	calendarHeading($displayYear, $displayMonth);
	calendarBody($displayYear, $displayMonth);
});

/* Prev */
$(document).on('tap', '#js_prev', function() {
	$displayMonth--;
	if($displayMonth < 1) {
		$displayYear--;
		$displayMonth = 12;
	}
	calendarHeading($displayYear, $displayMonth);
	calendarBody($displayYear, $displayMonth);
});


/* Selected */
$(document).on('tap', '.js_cell', function() {
	if(!$(this).hasClass('active') && $(this).html() != '&nbsp;'){
		$(this).addClass('active');
	}else{
		$(this).removeClass('active');
	}
});

/* Camera */
$(document).on('tap', '#js_camera_button', function() {
	$('#js_prev, #js_next').addClass('active');
	window.location = 'scheme://saveFunc?camera=on';
	$('#js_modal').fadeIn(50);
	setTimeout(function(){
		$('#js_modal').fadeOut(500);
	}, 100);
});

