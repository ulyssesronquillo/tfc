<?php include "header.php"; ?>

<article class="post-195 page type-page status-publish has-post-thumbnail entry" itemscope itemtype="https://schema.org/CreativeWork">
<header class="entry-header">
<h1 class="entry-title" itemprop="headline">Video</h1>
</header>
<div class="entry-content" itemprop="text">
  <div id="wrapper" class="center" style="max-width:960px;margin:10px auto;">
    <div id="playerZhvliajXlxTH"></div>
      <script type="text/javascript">jwplayer("playerZhvliajXlxTH").setup({
        autostart: true,
        fallback: true,
        width: "101%",
        aspectratio: "16:9",
        androidhls: true,
        image: "livestream.jpg",
        sources: [
          {
            file: "http://wowza.thefatherscall.org:1935/live/smil:livestream.smil/playlist.m3u8",
            type: "hls"
          },
          {
            file: "http://wowza.thefatherscall.org:1935/live/smil:livestream.smil/jwplayer.smil",
            type: "rtmp" 
          },
          {
            file: "http://wowza.thefatherscall.org:1935/live/smil:livestream.smil/manifest.mpd",
            type: "dash" 
          },
        ],
        rtmp: {
          bufferlength: "10"
        }
        });
        jwplayer().setVolume(90);
        jwplayer().play();
        jwplayer().onError(function(){
        jwplayer().load({file:"https://s3-us-west-1.amazonaws.com/tfcmedia/offair.mp4"});
        jwplayer().play();
        });
        var t;
        var timer=10000;
        jwplayer().onIdle(function() {
        t=setTimeout("location.reload(true)",timer);
        });
      </script> 
    </div>
    <div style="margin:10px 0;text-align:center;color:red;font-size:28px;">
      <?php echo $contents = file_get_contents("https://thefatherscall.org/alert.txt");?>
    </div>
    <div style="text-align:center"><a href="">Restart Player</a></div>
    <div style="text-align:center">
      <a href="audio.php">Audio Stream</a> | <a href="android.php">Android Player</a> | <a href="smarttv.php">Smart TV</a>
    </div>
    <div style="text-align: center; padding-bottom: 15px;">
      For Service times, please see<a href="https://thefatherscall.org/meeting-information/"> Meeting Information Page</a>.<br />
      Telephone hookup: (712) 770-4160. Code: 268964#.
    </div>
    <div style="text-align: center; padding-bottom: 15px;">
      <a href="https://thefatherscall.org/support/" target="_blanks"><button>Support</button></a>
    </div>
  </div>
</article>

<?php include "footer.php"; ?>