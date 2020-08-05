<?php
ini_set('error_reporting', E_ALL);
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);

require_once(dirname(__FILE__) . '/../config.php');

if (file_exists(dirname(__FILE__) . '/../vqmod/vqmod.php')) {
    require_once(dirname(__FILE__) . '/../vqmod/vqmod.php');
    VQMod::bootup();

    require_once(VQMod::modCheck(DIR_SYSTEM . 'library/config.php'));
    require_once(VQMod::modCheck(DIR_SYSTEM . 'library/db.php'));
    require_once(VQMod::modCheck(DIR_SYSTEM . 'library/db/' . DB_DRIVER . '.php'));
} else {
    require_once(DIR_SYSTEM . 'library/config.php');
    require_once(DIR_SYSTEM . 'library/db.php');
    require_once(DIR_SYSTEM . 'library/db/' . DB_DRIVER . '.php');
}

// Config
$config = new Config();
$config->load('default');

$db = new DB(DB_DRIVER, DB_HOSTNAME, DB_USERNAME, DB_PASSWORD, DB_DATABASE);

/** Check status */
$sale_analytics_status = $db->query("SELECT s.value FROM `" . DB_PREFIX . "setting` s WHERE s.key = 'sale_analytics_status'");
if ($sale_analytics_status->row['value'] == 0) {
    return false;
}

/** Query */
$sale_analytics_order_status = $db->query("SELECT s.value FROM `" . DB_PREFIX . "setting` s WHERE s.key = 'sale_analytics_order_status'")->row['value'];
$sale_analytics_data_rebuild = $db->query("SELECT s.value FROM `" . DB_PREFIX . "setting` s WHERE s.key = 'sale_analytics_data_rebuild'")->row['value'];

$where = '';
if ($sale_analytics_order_status > 0) {
    $where .= " AND fo.order_status_id = " . $sale_analytics_order_status;
}
if (!empty($sale_analytics_data_rebuild)) {
    $where .= " AND fo.date_added >= '" . $sale_analytics_data_rebuild . "'";
}

$sql = "
    SELECT o.order_id, o.date_added as order_date, o.order_status_id, op.product_id, op.name, op.model, op.quantity as q_remove, op.price, p.quantity as q_total, p.image
    FROM " . DB_PREFIX . "order_product op
    LEFT JOIN " . DB_PREFIX . "product p ON p.product_id = op.product_id
    LEFT JOIN " . DB_PREFIX . "order o ON o.order_id = (
        SELECT MIN(fo.order_id)
        FROM " . DB_PREFIX . "order fo 
        WHERE fo.flag_index_rebuild = 0 " . $where . "
    ) 
    WHERE op.order_id = o.order_id
    ";
$query = $db->query($sql);
pre($query->num_rows);
pre($query->rows);

if ($query->num_rows > 0) {
    foreach ($query->rows as $row) {
        $order_id = $row['order_id'];

        $db->query("INSERT INTO `sale_analytics` (`product_id`, `model`, `name`, `image`, `price`, `q_remove`, `q_total`, `order_id`, `order_status_id`, `order_date`) VALUES (" . (int)$row['product_id'] . ", '" . $row['model'] . "', '" . $row['name'] . "', '" . $row['image'] . "', '" . $row['price'] . "', '" . $row['q_remove'] . "', '" . $row['q_total'] . "', '" . $row['order_id'] . "', '" . $row['order_status_id'] . "', '" . $row['order_date'] . "' );");
    }

    $db->query("UPDATE `" . DB_PREFIX . "order` SET flag_index_rebuild = 1 WHERE order_id = " . $order_id);
}


function pre($arr)
{
    echo '<pre>';
    print_r($arr);
    echo '</pre>';
}
