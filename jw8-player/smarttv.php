<?php include "header.php"; ?>

<article class="post-195 page type-page status-publish has-post-thumbnail entry" itemscope itemtype="https://schema.org/CreativeWork">
	<header class="entry-header">
	  <h1 class="entry-title" itemprop="headline">Video</h1>
	</header>
	<div class="entry-content" itemprop="text">
    <div id="wrapper" style="max-width:960px;margin:10px auto">
		  <div id="player"> 
		    <video id="video" width="100%" height="auto" controls autoplay> 
		      <source src="http://wowza.thefatherscall.org:1935/live/livestream/playlist.m3u8" type="video/mp4"> 
		      Your browser does not support the video tag.
		    </video> 
		  </div>
		</div>
    <div style="margin:10px 0;text-align:center;color:red;font-size:28px;">
	    <?php echo $contents = file_get_contents("https://thefatherscall.org/alert.txt");?>
    </div>
    <div style="text-align:center">
      <a href="index.php">Video Stream</a> | <a href="android.php">Android Player</a> | <a href="smarttv.php">Smart TV</a>
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