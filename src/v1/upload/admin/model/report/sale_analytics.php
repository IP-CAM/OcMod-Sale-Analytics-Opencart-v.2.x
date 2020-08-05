<?php
class ModelReportSaleAnalytics extends Model
{
    public function saveConfig($data = array())
    {
        $this->load->model('setting/setting');
        $fields =  array(
            'sale_analytics_status' => $this->db->escape($data['sale_analytics_status']),
            'sale_analytics_order_status' => $this->db->escape($data['sale_analytics_order_status']),
            'sale_analytics_data_rebuild' => !empty($data['sale_analytics_data_rebuild']) ? $this->db->escape($data['sale_analytics_data_rebuild']) : $this->getMinOrderData()
        );
        $this->model_setting_setting->editSetting('sale_analytics', $fields);

        return true;
    }

    public function addFlagRebuild()
    {
        $sql = "ALTER TABLE `" . DB_PREFIX . "order`  ADD `flag_index_rebuild` TINYINT(1) UNSIGNED NOT NULL DEFAULT '0'  AFTER `date_modified`,  ADD   INDEX  `flag_index_rebuild` (`flag_index_rebuild`);";
        $this->db->query($sql);
    }

    public function removeFlagRebuild()
    {
        $sql = "ALTER TABLE `" . DB_PREFIX . "order`  DROP `flag_index_rebuild`;";
        $this->db->query($sql);
    }

    public function setFlagRebuild()
    {
        $this->load->model('setting/setting');
        $sale_analytics = $this->model_setting_setting->getSetting('sale_analytics');
        $sale_analytics_order_status = $sale_analytics['sale_analytics_order_status'];
        $sale_analytics_data_rebuild = $sale_analytics['sale_analytics_data_rebuild'];

        $this->truncateTable();
        $this->resetFlagRebuild();

        $sql = "UPDATE `" . DB_PREFIX . "order` SET flag_index_rebuild = 0 WHERE 1";

        if (!empty($sale_analytics_data_rebuild)) {
            $sql .= " AND date_added >= '" . $sale_analytics_data_rebuild . "'";
        }

        if ($sale_analytics_order_status > 0) {
            $sql .= " AND order_status_id = " . $sale_analytics_order_status . "";
        }

        $this->db->query($sql);
    }

    public function getQuerySelectedOrders()
    {
        $sql = "SELECT order_id FROM `" . DB_PREFIX . "order` WHERE flag_index_rebuild = 0";
        return $this->db->query($sql);
    }

    public function resetFlagRebuild()
    {
        $this->db->query("UPDATE `" . DB_PREFIX . "order` SET flag_index_rebuild = 1");
    }

    public function getMinOrderData()
    {
        $query = $this->db->query("SELECT MIN(date_added) as date_added FROM `" . DB_PREFIX . "order`");
        return $query->row['date_added'];
    }

    public function getFilterResult($filter)
    {
        $sql = "SELECT sa.* FROM `sale_analytics` sa";

        if (!empty($filter['filter_category'])) {
            $sql .= " INNER JOIN `" . DB_PREFIX . "product_to_category` p2c ON p2c.`category_id` = " . intval($filter['filter_category']) . " AND p2c.`product_id` = sa.`product_id`";
        }

        $sql .= " WHERE 1";

        if (!empty($filter['filter_name'])) {
            $sql .= " AND sa.`name` LIKE '" . $this->db->escape($filter['filter_name']) . "%'";
        }

        if (!empty($filter['filter_model'])) {
            $sql .= " AND sa.`model` LIKE '" . $this->db->escape($filter['filter_model']) . "%'";
        }

        if (!empty($filter['filter_date_start'])) {
            $sql .= " AND sa.`order_date` >= '" . $this->db->escape($filter['filter_date_start']) . "'";
        }

        if (!empty($filter['filter_date_end'])) {
            $sql .= " AND sa.`order_date` <= '" . $this->db->escape($filter['filter_date_end']) . "'";
        }

        $sql .= " ORDER BY sa.`product_id` ASC, sa.`order_date` ASC";
        //$sql .= " LIMIT 0, 50";

        //pre($sql);
        return $this->db->query($sql)->rows;
    }

    public function checkTable()
    {
        $check_db = $this->db->query("SHOW TABLES LIKE 'sale_analytics';");

        return $check_db->num_rows != 0;
    }

    public function addTable()
    {
        $createTableSql = "CREATE TABLE IF NOT EXISTS `sale_analytics` (
					`product_id` INT(11) NULL DEFAULT NULL,
                    `model` VARCHAR(64) NULL DEFAULT NULL,
					`name` VARCHAR(255) NULL DEFAULT NULL,
					`image` VARCHAR(255) NULL DEFAULT NULL,
					`price` DECIMAL(15,4) NOT NULL DEFAULT 0.0000,
					`q_remove` INT(11) UNSIGNED NULL DEFAULT NULL,
					`q_add` INT(11) UNSIGNED NULL DEFAULT NULL,
					`q_total`INT(11) UNSIGNED NULL DEFAULT NULL,
					`order_id` INT(11) UNSIGNED NULL DEFAULT NULL,
					`order_date` DATE NOT NULL DEFAULT '0000-00-00'
				)
				COLLATE='utf8_general_ci'
				ENGINE=InnoDB
                ;";
        $this->db->query($createTableSql);
    }

    public function removeTable()
    {
        $this->db->query("DROP TABLE `sale_analytics`");
    }

    public function truncateTable()
    {
        $this->db->query("TRUNCATE `sale_analytics`");
    }

    /** SAMPLE */
    public function getTotalSales($data = array())
    {
        $sql = "SELECT SUM(total) AS total FROM `" . DB_PREFIX . "order` WHERE order_status_id > '0'";

        $sql .= " AND order_status_id IN(" . implode(",", $this->config->get('config_complete_status')) . ") ";

        if (!empty($data['filter_date_added'])) {
            $sql .= " AND DATE(date_added) = DATE('" . $this->db->escape($data['filter_date_added']) . "')";
        }

        $query = $this->db->query($sql);

        return $query->row['total'];
    }
}
