<?php
class ControllerExtensionModuleSaleAnalytics extends Controller
{
    private $error = array();

    public function index()
    {
        /** Prepare */
        $this->load->language('extension/module/sale_analytics');

        $this->document->setTitle($this->language->get('heading_title'));

        $this->load->model('setting/setting');
        $this->load->model('report/sale_analytics');

        /** POST data */
        if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validate()) {
            if ($this->model_report_sale_analytics->saveConfig($this->request->post)) {
                $this->model_report_sale_analytics->setFlagRebuild();
            }

            $this->session->data['success'] = $this->language->get('text_success');

            $this->response->redirect($this->url->link('extension/extension', 'token=' . $this->session->data['token'] . '&type=module', true));
        }

        /** Texts */
        $data['heading_title'] = $this->language->get('heading_title');

        $data['text_form_config'] = $this->language->get('text_form_config');
        $data['text_missing'] = $this->language->get('text_missing');
        $data['text_enabled'] = $this->language->get('text_enabled');
        $data['text_disabled'] = $this->language->get('text_disabled');
        $data['text_warning_rebuild'] = $this->language->get('text_warning_rebuild');

        $data['entry_data_rebuild'] = $this->language->get('entry_data_rebuild');
        $data['entry_order_status'] = $this->language->get('entry_order_status');
        $data['entry_rebuild'] = $this->language->get('entry_rebuild');

        $data['button_save'] = $this->language->get('button_save');
        $data['button_cancel'] = $this->language->get('button_cancel');

        if (isset($this->error['warning'])) {
            $data['error_warning'] = $this->error['warning'];
        } else {
            $data['error_warning'] = '';
        }

        /** Breadcrumbs */
        $data['breadcrumbs'] = array();
        $data['breadcrumbs'][] = array(
            'text' => $this->language->get('text_home'),
            'href' => $this->url->link('common/dashboard', 'token=' . $this->session->data['token'], true)
        );
        $data['breadcrumbs'][] = array(
            'text' => $this->language->get('text_extension'),
            'href' => $this->url->link('extension/extension', 'token=' . $this->session->data['token'] . '&type=module', true)
        );
        $data['breadcrumbs'][] = array(
            'text' => $this->language->get('heading_title'),
            'href' => $this->url->link('extension/module/sale_analytics', 'token=' . $this->session->data['token'], true)
        );

        /** Links */
        $data['action'] = $this->url->link('extension/module/sale_analytics', 'token=' . $this->session->data['token'], true);

        $data['cancel'] = $this->url->link('extension/extension', 'token=' . $this->session->data['token'] . '&type=module', true);

        /** Fields data */
        if (isset($this->request->post['sale_analytics_status'])) {
            $data['sale_analytics_status'] = $this->request->post['sale_analytics_status'];
        } else {
            $data['sale_analytics_status'] = $this->config->get('sale_analytics_status');
        }

        if (isset($this->request->post['sale_analytics_order_status'])) {
            $data['sale_analytics_order_status'] = $this->request->post['sale_analytics_order_status'];
        } else {
            $data['sale_analytics_order_status'] = $this->config->get('sale_analytics_order_status');
        }

        if (isset($this->request->post['sale_analytics_data_rebuild'])) {
            $data['sale_analytics_data_rebuild'] = $this->request->post['sale_analytics_data_rebuild'];
        } else {
            $data['sale_analytics_data_rebuild'] = $this->config->get('sale_analytics_data_rebuild');
        }

        /** Order statuses */
        $this->load->model('localisation/order_status');
        $data['order_statuses'] = $this->model_localisation_order_status->getOrderStatuses();

        /** Blocks */
        $data['header'] = $this->load->controller('common/header');
        $data['column_left'] = $this->load->controller('common/column_left');
        $data['footer'] = $this->load->controller('common/footer');

        $this->response->setOutput($this->load->view('extension/module/sale_analytics', $data));
    }

    protected function validate()
    {
        if (!$this->user->hasPermission('modify', 'extension/module/sale_analytics')) {
            $this->error['warning'] = $this->language->get('error_permission');
        }

        return !$this->error;
    }

    public function install()
    {
        $this->load->model('report/sale_analytics');

        $check_table = $this->model_report_sale_analytics->checkTable();
        if ($check_table) {
            return false;
        }

        $this->model_report_sale_analytics->addFlagRebuild();
        $this->model_report_sale_analytics->addTable();

        // Add key for cron task 
        $this->load->model('setting/setting');
        $fields =  array(
            'sale_analytics_status' => 0,
            'sale_analytics_order_status' => 0,
            'sale_analytics_data_rebuild' => $this->model_report_sale_analytics->getMinOrderData()
        );
        $this->model_setting_setting->editSetting('sale_analytics', $fields);
    }

    public function uninstall()
    {
        $this->load->model('report/sale_analytics');

        $check_table = $this->model_report_sale_analytics->checkTable();
        if (!$check_table) {
            return false;
        }

        $this->model_report_sale_analytics->removeFlagRebuild();
        $this->model_report_sale_analytics->removeTable();

        // Remove key for cron task 
        $this->load->model('setting/setting');
        $this->model_setting_setting->deleteSetting('sale_analytics');
    }
}
