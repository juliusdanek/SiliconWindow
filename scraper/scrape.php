<?php

error_reporting(E_ALL);
include_once('simple_html_dom.php');

// Create DOM from URL or file
$html = file_get_html('https://www.funderbeam.com/startups/evermind');

// Find all images 
foreach($html->find('img') as $element) 
       echo $element->src . '<br /><br />';

// Find all links 
foreach($html->find('a') as $element) 
       echo $element->href . '<br /><br />';



?>