$(document).ready(function(){


  // $(document).on('turbolinks:load', function() {
  //   console.log('load')
  //   $('.dropdown-toggle').dropdown()
  //   $('[data-toggle="tooltip"]').tooltip()
  // })
  
});
import "flatpickr";
import { Mandarin } from "flatpickr/dist/l10n/zh.js"

document.addEventListener('turbolinks:load', () => {
  let startDate = document.querySelector('.start_date')
  if(startDate) {
    flatpickr(startDate, {
      locale: Mandarin,
      enableTime: true,
      dateFormat: "Y-m-d H:i",
      time_24hr: true
    });
  }


  let endDate = document.querySelector('.end_date')
  if(endDate) {
    flatpickr(endDate, {
      enableTime: true,
      locale: Mandarin,
      dateFormat: "Y-m-d H:i",
      time_24hr: true
    });
  }

})


