// How to use: https://github.com/mdehoog/Semantic-UI-Calendar

$(document).on('turbolinks:load', function() {
  $('.ui.calendar').calendar({
    type: 'date',
    minDate: new Date(),
    ampm: false,
    text: {
      days: ['日', '月', '火', '水', '木', '金', '土'],
      months: ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'],
      monthsShort: ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'],
    },
    formatter: {
      date: function (date) {
        var day = ('0' + date.getDate()).slice(-2);
        var month = ('0' + (date.getMonth() + 1)).slice(-2);
        var year = date.getFullYear();
        return year + '/' + month + '/' + day;
      }
    }
  });
});
