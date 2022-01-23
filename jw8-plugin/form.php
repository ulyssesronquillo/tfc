<?php
// if submit form
if($_POST['tfc_jwp_hidden'] == 'Y') :
  // store data
  $tfc_jwp_hosted = $_POST['tfc_jwp_hosted'];
  update_option('tfc_jwp_hosted', $tfc_jwp_hosted);
  // display message
  ?>
  <div class="updated"><p><strong><?php _e('Options were saved.' ); ?></strong></p></div>
  <?php 
else :
  // normal page display
  $tfc_jwp_hosted = get_option('tfc_jwp_hosted');
endif;
?>
<div class="wrap">
  <?php echo "<h2>" . __( 'JWPlayer', 'tfc_jwp' ) . "</h2>"; ?>
  <form name="tfc_jwp_form" method="post" action="<?php echo str_replace( '%7E', '~', $_SERVER['REQUEST_URI']); ?>">
  <input type="hidden" name="tfc_jwp_hidden" value="Y">
  <h3><?php _e("JWPlayer Hosting Option" ); ?></h3>
  <p>Choose a player to use: JWPlayer CDN (Content Delivery Network) or Self-Hosted Player</p>
  <p>The default is: <code>JWPlayer CDN</code></p>
  <select name="tfc_jwp_hosted">
    <option value="cdn" <?php if ($tfc_jwp_hosted=="cdn") : echo "selected"; endif; ?> >JWPlayer CDN</option>
    <option value="self-hosted" <?php if ($tfc_jwp_hosted=="self-hosted") : echo "selected"; endif; ?> >Self-hosted Player</option>
  </select>
  <p class="submit"><input type="submit" name="Submit" value="<?php _e('Save', 'tfc_jwp' ) ?>" /></p>
  </form>
  <hr />
  <h4>Check <a href="https://thefatherscall.org/wp-admin/options-general.php?page=syntax%2Fsyntax.php">here</a> to see format.</h4>
</div>
