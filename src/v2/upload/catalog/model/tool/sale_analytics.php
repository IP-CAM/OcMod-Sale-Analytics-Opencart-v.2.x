<?php
class ModelToolSaleAnalytics extends Model
{
    public function changeStatus($order_id, $order_status_id)
    {
        $this->db->query("UPDATE `sale_analytics` SET `order_status_id` = '" . (int)$order_status_id . "' WHERE `order_id` = '" . (int)$order_id . "';");
    }
}
