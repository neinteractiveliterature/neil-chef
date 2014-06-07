<?php

define("GRAPHVIZ_PATH", "/usr/bin");

if ($_REQUEST["program"] == "dot") {
  $program = "dot";
} else {
  $program = "neato";
}

if ($_REQUEST["format"]) {
  $format = $_REQUEST["format"];
} else {
  $format = "xdot";
}

$dspec = array( 0 => array("pipe", "r"), 1 => array("pipe", "w") );
$cmd = GRAPHVIZ_PATH . "/" . $program . " -T$format 2>&1";
$process = proc_open($cmd, $dspec, $pipes);

if (is_resource($process)) {
  fwrite($pipes[0], $_REQUEST["data"]);
  fclose($pipes[0]);

  $data = stream_get_contents($pipes[1]);
  fclose($pipes[1]);

  $ret = proc_get_status($process);
  proc_close($process);

  header("Content-type: text/plain");
  if ($ret["exitcode"] != 0) {
    header("HTTP/1.1 500 Internal Server Error");
  }
  echo $data;

} else {
  header("HTTP/1.1 500 Internal Server Error");
}

?>