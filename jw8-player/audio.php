<?php include "header.php"; ?>

<article class="post-195 page type-page status-publish has-post-thumbnail entry" itemscope itemtype="https://schema.org/CreativeWork">
  <header class="entry-header">
		<h1 class="entry-title" itemprop="headline">Audio</h1>
  </header>
  <div class="entry-content" itemprop="text">
    <div id="wrapper" style="width:400px;margin:10px auto">
      <p><div id="icecast"></div></p>
      <script type="text/javascript">
        jwplayer("icecast").setup({
          width: 400,
          height: 34,
          file: "http://thefatherscall.org:8000/live.ogg",
          type: "mp3",
        });
        jwplayer().onError(function(){
          jwplayer().load({file:"https://s3-us-west-1.amazonaws.com/tfcmedia/offair.mp3"});
          jwplayer().play();
        });
        var t;
        var timer=10000;
        jwplayer().onIdle(function() {
          t=setTimeout("jwplayer().play()",timer);
        });
      </script>
		</div>
    <div style="margin:10px 0;text-align:center;color:red;font-size:28px;">
    <?php echo $contents = file_get_contents("https://thefatherscall.org/alert.txt");?>
    </div>
    <div style="text-align:center"><a href="">Restart Player</a></div>
    <div style="text-align:center">
      <a href="index.php">Video Stream</a>
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