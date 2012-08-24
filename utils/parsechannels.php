<?php
$jsonButtons = '[{"key":"on-off","code1":"652","code2":"2700"},{"key":"info","code1":"655","code2":"2703"},{"key":"1","code1":"641","code2":"2689"},{"key":"2","code1":"642","code2":"2690"},{"key":"3","code1":"643","code2":"2691"},{"key":"4","code1":"644","code2":"2692"},{"key":"5","code1":"645","code2":"2693"},{"key":"6","code1":"646","code2":"2694"},{"key":"7","code1":"647","code2":"2695"},{"key":"8","code1":"648","code2":"2696"},{"key":"9","code1":"649","code2":"2697"},{"key":"0","code1":"640","code2":"2688"}]';


$path = './channels.conf';

//$channels = parseChannels($path);
$buttons = json_decode($jsonButtons);
$k = getCode(5, $buttons);
var_dump($k);

function getCode($key, $buttons) {
    foreach ($buttons as $b) {
        if ($b->key == $key) {
            return $b;
        }
    }
    return null;
}

function parseChannels($path) {
    $columns = array('name', 'frequency', 'parameters', 'bandwidth', 'fec_rate', 'fec_rate_lp', 'phase_modulation', 'transmission_mode', 'guard_interval', 'hierarchy', 'video_pid', 'audio_channel', 'service_id');
    $result = array();
    $content = file_get_contents($path);
    $lines = split("\n", $content);
    foreach ($lines as $i=>$line) {
        
        $data = split(':', $line);
        if (count($data)==1) {continue;}
        $channel = array();
        foreach ($columns as $j=>$field) {
            $channel[$field] = $data[$j];
        }
        
        $result[] = $channel;
        
    }
    return $result;
}


?>
