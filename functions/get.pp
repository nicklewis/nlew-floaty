function floaty::get(
  String[1] $platform,
  Integer[1] $count = 1
) {
  $result = run_task(floaty::get, localhost, platform => $platform, count => $count)
  $nodes = $result.first['nodes']

  if $count == 1 {
    $nodes[0]
  } else {
    $nodes
  }
}
