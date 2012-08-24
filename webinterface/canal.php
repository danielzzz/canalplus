<?php 

$jsonButtons = '[{"key":"on-off","code1":"652","code2":"2700"},{"key":"info","code1":"655","code2":"2703"},{"key":"1","code1":"641","code2":"2689"},{"key":"2","code1":"642","code2":"2690"},{"key":"3","code1":"643","code2":"2691"},{"key":"4","code1":"644","code2":"2692"},{"key":"5","code1":"645","code2":"2693"},{"key":"6","code1":"646","code2":"2694"},{"key":"7","code1":"647","code2":"2695"},{"key":"8","code1":"648","code2":"2696"},{"key":"9","code1":"649","code2":"2697"},{"key":"0","code1":"640","code2":"2688"}]';

$codes = json_decode($jsonButtons);




$host = $_SERVER['HTTP_HOST'];

$plusJSON = file_get_contents('./channels_plus.js');
$plus = json_decode($plusJSON);

//file_put_contents('./channels_plus.js', json_encode($plus, JSON_PRETTY_PRINT));





function findCode($key) {
    global $codes;
    foreach($codes as $c) {
        if ($c->key == $key) {
            return $c->code1;
        }
    }
    
    return 0;
}

function parseCode($c) {
    $codes =array();
    $nums = str_split($c);
    foreach ($nums as $n) {
        $codes[]=findCode($n);   
    }
    return $codes;
}

function getCanalName($n) {
    $a = explode("/", $n);
    return $a[count($a)-2];
}


?>
<!doctype html>
<html>
<head>
    <title>control center</title>

<meta name="HandheldFriendly" content="True">
<meta name="MobileOptimized" content="320">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

</head>
<body style="font-size: 140%; color: #333; background: white;">
<div class="info" style="display: none; font-size: 200%; position:fixed; top:0; text-align: center; width:98%; background-color: yellow">ok</div>
<h1 style="margin:0px; padding:0px; ">CANAL+</h1>
<div style="background-color: black">

<?php foreach($plus as $c): ?>
<?php if(strpos(getCanalName($c->url), 'hd') !== false ) { continue; } ?>
<div style="float: left; margin-right: 3px; margin-bottom: 3px;"><a href="http://<?php echo $host ?>:25051/arduino/irsend/<?php echo join(':', parseCode($c->code)) ?>"><img src="/img/cplus/<?php echo $c->code ?>.png" alt="<?php echo getCanalName($c->url) ?>: <?php echo $c->title ?>" /></a></div>
<?php endforeach; ?>
</div>
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.min.js"></script>
<script>!window.jQuery && document.write(unescape('%3Cscript src="/js/jquery-1.6.2.min.js"%3E%3C/script%3E'))</script>
<script>
$(document).ready(function(){
    $('a').click(function(e){
        var url = $(this).attr('href');
        $.get(url, function(r){
            var msg = r == "ok" ? r : "error";
            $('.info').text(msg);
            $('.info').fadeIn('fast');
            setTimeout(function(){
                $('.info').fadeOut();
            }, 2000);
        });
        return false;
    })
})
</script>

</body>
</html>
