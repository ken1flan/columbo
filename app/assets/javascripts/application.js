// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require twitter/bootstrap
//= require turbolinks
//= require_tree .

// 共通の初期設定
$(function () {
  var $container = $('#masonry_container');

  $container.imagesLoaded(function(){
    $container.masonry({
      itemSelector: '.item'
    });
  }); //

  $container.infinitescroll({
      navSelector: '.pagination',
      nextSelector: '.next a',
      itemSelector: '.item'
    },
    function ( newElements ) {
      var $newElements = $( newElements );
      $newElements.imagesLoaded( function () {
        $container.masonry('appended', $newElements, true);
      });
    }
  );
});


// pickup_tweetのいいねボタン処理
$(document).on('click', '.likePickupTweet', function () {
  var id = $(this).attr("id").substring(18);
  var up_down;
  if($(this).children(".star").attr("class").indexOf("star-empty") > 0){
    up_down = 'up';
  } else {
    up_down = 'down';
  }
  $.getJSON('/reputation/pickup_tweets/' + id + '/' + up_down + '.json', function (json) {
    var button = $("#like_pickup_tweet_" + json.id);
    if(json.evaluation_value == 0){
      button.children(".star").removeClass("glyphicon-star");
      button.children(".star").addClass("glyphicon-star-empty");
    } else {
      button.children(".star").removeClass("glyphicon-star-empty");
      button.children(".star").addClass("glyphicon-star");
    }
    button.children(".value").text(json.likes_count);
  });
});
