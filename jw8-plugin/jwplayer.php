<?php
/*
Plugin Name: TFC JWPlayer 8 
Plugin URI: http://uly.me
Description: A WordPress plugin for TFC JWPlayer 8
Version: 1.0
Author: Ulysses Ronquillo
Author URI: http://uly.me
*/

/* 
Usage 
[jwpvideo src="filename" autoplay="true"]



*/

// include the form
function tfc_jwp_form() 
{
  include('form.php');
}

// add this plugin under the appearance theme pages
function tfc_jwp_options() 
{
  add_options_page( 'JWPlayer', 'JWPlayer', 'manage_options', __FILE__, 'tfc_jwp_form' );
}
add_action( 'admin_menu', 'tfc_jwp_options' );

// jwplayer video on demand
function jwp_vod_player($atts) 
{
  extract( shortcode_atts( array('src' => '', 'poster' => '', 'autoplay' => ''), $atts ));
  if ($poster=='') : $poster = 'https://d3ac22n9fojsk1.cloudfront.net/intro.png'; endif;
  if ($autoplay=='true') : $autoplay = 'true'; else: $autoplay='false'; endif;
  return '
  <div id="wrapper" class="center" style="max-width:960px;margin:0px auto;">
  <div id="videoX5LYsrKqwuMT"></div>
  <script type="text/javascript">
    jwplayer("videoX5LYsrKqwuMT").setup({
    sources: [{
      file: "https://d3ac22n9fojsk1.cloudfront.net/'.$src.'",
    }],
    image: "'.$poster.'",
    width: "100%",
    aspectratio: "16:9",
    autostart: '.$autoplay.',
    });
  </script>
  </div>';
}
add_shortcode('jwpvideo', 'jwp_vod_player');

// jwplayer audio on demand
function jwp_aod_player($atts) 
{
  extract( shortcode_atts( array('src' => ''), $atts ));
  if ( wp_is_mobile() ) : $player_width = '270'; else : $player_width = '400'; endif;  
  return '
  <div id="wrapper" style="width:'.$player_width.'px;margin:0px auto">
    <p><div id="audio468oRt2L2Ia2"></div></p>
    <script type="text/javascript">
      jwplayer("audio468oRt2L2Ia2").setup({
      width: '.$player_width.',
      height: 34,
      file: "https://d3ac22n9fojsk1.cloudfront.net/'.$src.'",
      type: "mp3",
      autostart: false,
      });
    </script>
  </div>';
}
add_shortcode('jwpaudio', 'jwp_aod_player');

// jwplayer video playlist
function jwp_vod_list($atts) 
{
  extract( shortcode_atts( array('src' => '', 'poster' => '',), $atts ));
  if ($poster=='') : $poster = 'https://d2351u6wgczaw2.cloudfront.net/wp-content/uploads/2017/08/Intro-Picture.png'; endif;
  return '
  <div id="wrapper" class="center" style="max-width:960px;margin:0px auto;">
    <div id="videoX5LYsrKqwuMT"></div>
      <script type="text/javascript">
        jwplayer("videoX5LYsrKqwuMT").setup({
          file: "https://d3ac22n9fojsk1.cloudfront.net/'.$src.'",
          image: "'.$poster.'",
          width: "100%",
          aspectratio: "16:9",
          autostart: "false"
        });
        function playVideo(video) { 
          jwplayer().load([{
             file: "https://d3ac22n9fojsk1.cloudfront.net/" + video,
          }]);
          jwplayer().play();
        }
      </script>
  </div>';
}
add_shortcode('jwpvideo-playlist', 'jwp_vod_list');

// jwplayer audio playlist
function jwp_aod_list($atts) 
{
  extract( shortcode_atts( array('src' => '', 'poster' => '',), $atts ));
  if ( wp_is_mobile() ) : $player_width = '270'; else : $player_width = '270'; endif; 
  return '
  <div id="wrapper" class="center" style="max-width:'.$player_width.'px;margin:0px auto;">
    <div id="audio468oRt2L2Ia2"></div>
      <script type="text/javascript">
        jwplayer("audio468oRt2L2Ia2").setup({
          width: "'.$player_width.'",
          height: "34",
          file: "https://d3ac22n9fojsk1.cloudfront.net/'.$src.'",
          type: "mp3",          
          autostart: "false"
        });
        function playAudio(audio) { 
          jwplayer("audio468oRt2L2Ia2").load([{
             file: "https://d3ac22n9fojsk1.cloudfront.net/" + audio
          }]);
          jwplayer("audio468oRt2L2Ia2").play();
        }
      </script>
  </div>';
}
add_shortcode('jwpaudio-playlist', 'jwp_aod_list');

// load jwplayer on the head section 
function tfc_jwplayer() 
{ 
  $tfc_jwp_hosted = get_option('tfc_jwp_hosted');
  if ($tfc_jwp_hosted=="cdn") :    
    // cdn player
    echo '<script src="https://cdn.jwplayer.com/libraries/ctRJSy1Y.js"></script>';  echo "\r\n";
  else:
    // self-hosted player
    echo '<script src="//thefatherscall.org/jwplayer/jwplayer.js"></script>'; echo "\r\n";
    echo '<script>jwplayer.key="an4/LmDqPJ27Hcaz3okmWds7jgm2Dc1zcuHdHg3kEIY=";</script>'; echo "\r\n";
  endif;
}
add_action( 'wp_head', 'tfc_jwplayer', 100 );

// add ccs
function tfc_jwplayer_playlist_style()
{
  // Register the style like this for a plugin:
  wp_register_style( 'tfc-jwplayer-playlist-style', plugins_url( '/css/style.css', __FILE__ ), array(), '20170721', 'all' );
  // For either a plugin or a theme, you can then enqueue the style:
  wp_enqueue_style( 'tfc-jwplayer-playlist-style' );
}
add_action( 'wp_enqueue_scripts', 'tfc_jwplayer_playlist_style' );
