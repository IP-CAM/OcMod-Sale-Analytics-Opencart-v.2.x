<?php
class ControllerReportSaleAnalytics extends Controller
{
    public function index()
    {
        /** Prepare */
        $this->load->language('report/sale_analytics');
        $this->load->model('report/sale_analytics');
        $this->document->setTitle($this->language->get('heading_title'));
        $data['sale_analytics_status'] = $sale_analytics_status = $this->config->get('sale_analytics_status');
        $data['token'] = $this->session->data['token'];

        /** Filter data */
        if (isset($this->request->get['filter_date_start'])) {
            $filter_date_start = $this->request->get['filter_date_start'];
        } else {
            $filter_date_start = date('Y-m-d', strtotime(date('Y') . '-' . date('m') . '-01'));
        }
        if (isset($this->request->get['filter_date_end'])) {
            $filter_date_end = $this->request->get['filter_date_end'];
        } else {
            $filter_date_end = date('Y-m-d');
        }
        if (isset($this->request->get['filter_name'])) {
            $filter_name = $this->request->get['filter_name'];
        } else {
            $filter_name = null;
        }
        if (isset($this->request->get['filter_model'])) {
            $filter_model = $this->request->get['filter_model'];
        } else {
            $filter_model = null;
        }
        if (isset($this->request->get['filter_category'])) {
            $filter_category = $this->request->get['filter_category'];
        } else {
            $filter_category = NULL;
        }
        if (isset($this->request->get['page'])) {
            $page = $this->request->get['page'];
        } else {
            $page = 1;
        }

        /** Filter data */
        $data['filter_date_start'] = $filter_date_start;
        $data['filter_date_end'] = $filter_date_end;
        $data['filter_name'] = $filter_name;
        $data['filter_model'] = $filter_model;
        $data['filter_category'] = $filter_category;

        /** URL with filter data */
        $url = '';
        if (isset($this->request->get['filter_date_start'])) {
            $url .= '&filter_date_start=' . $this->request->get['filter_date_start'];
        }
        if (isset($this->request->get['filter_date_end'])) {
            $url .= '&filter_date_end=' . $this->request->get['filter_date_end'];
        }
        if (isset($this->request->get['filter_name'])) {
            $url .= '&filter_name=' . urlencode(html_entity_decode($this->request->get['filter_name'], ENT_QUOTES, 'UTF-8'));
        }
        if (isset($this->request->get['filter_model'])) {
            $url .= '&filter_model=' . urlencode(html_entity_decode($this->request->get['filter_model'], ENT_QUOTES, 'UTF-8'));
        }
        if (isset($this->request->get['filter_category'])) {
            $url .= '&filter_category=' . urlencode(html_entity_decode($this->request->get['filter_category'], ENT_QUOTES, 'UTF-8'));
        }
        if (isset($this->request->get['page'])) {
            $url .= '&page=' . $this->request->get['page'];
        }

        /** Calculate period filter days */
        $filter_date_start_ts = strtotime($filter_date_start);
        $filter_date_end_ts = strtotime($filter_date_end);
        $data['periodDays'] = ($filter_date_end_ts - $filter_date_start_ts) / (60 * 60 * 24);

        /** Filter result */
        $this->load->model('tool/image');
        $filter_result = array();
        $filter_data = array(
            'filter_date_start'         => $filter_date_start,
            'filter_date_end'         => $filter_date_end,
            'filter_name'      => $filter_name,
            'filter_model'      => $filter_model,
            'filter_category' => $filter_category,
            // 'start'                  => ($page - 1) * $this->config->get('config_limit_admin'),
            // 'limit'                  => $this->config->get('config_limit_admin')
        );
        $filter_result_q = $this->model_report_sale_analytics->getFilterResult($filter_data);
        if (!empty($filter_result_q)) {
            foreach ($filter_result_q as $fr) {
                $res = $filter_result[$fr['product_id']];

                $res['product_id'] = $fr['product_id'];
                $res['name'] = $fr['name'];
                $res['price'] = $fr['price'];
                $res['q_total'] = $fr['q_total'];

                $res['url_product_edit'] = $this->url->link('catalog/product/edit', 'token=' . $data['token'] . '&product_id=' . $fr['product_id'], true);

                if (is_file(DIR_IMAGE . $fr['image'])) {
                    $image = $this->model_tool_image->resize($fr['image'], 60, 60);
                    $image_big = $this->model_tool_image->resize($fr['image'], 200, 200);
                    $image_full = HTTPS_CATALOG . 'image/' . $fr['image'];
                } else {
                    $image = $this->model_tool_image->resize('no_image.png', 60, 60);
                    $image_big = $this->model_tool_image->resize('no_image.png', 200, 200);
                    $image_full = HTTPS_CATALOG . 'image/' . 'no_image.png';
                }
                $res['image'] = $image;
                $res['image_big'] = $image_big;
                $res['image_full'] = $image_full;

                if (!empty($fr['q_remove'])) {
                    $res['q_remove'][] = array(
                        'value' => $fr['q_remove'],
                        'order_date' => $fr['order_date'],
                        'order_id' => $fr['order_id'],
                        'order_link' => $this->url->link('sale/order/info', 'token=' . $data['token'] . '&order_id=' . $fr['order_id'], true),
                    );
                    $res['q_add'][] = array(
                        'value' => $fr['q_remove'],
                        'order_date' => $fr['order_date'],
                    );

                    if (!empty($res['total_remove'])) {
                        $res['total_remove'] += $fr['q_remove'];
                    } else {
                        $res['total_remove'] = $fr['q_remove'];
                    }

                    if (!empty($res['total_price'])) {
                        $res['total_price'] += $fr['price'] * $fr['q_remove'];
                    } else {
                        $res['total_price'] = $fr['price'] * $fr['q_remove'];
                    }
                }

                if (!empty($fr['q_add'])) {
                    $res['q_add'][] = array(
                        'value' => $fr['q_add'],
                        'order_date' => $fr['order_date'],
                    );
                }

                $filter_result[$fr['product_id']] = $res;
            }
        }

        $data['filter_result'] = json_encode(array_values($filter_result));
        /** ..Filter result */

        /** Breadcrumbs */
        $data['breadcrumbs'] = array();
        $data['breadcrumbs'][] = array(
            'text' => $this->language->get('text_home'),
            'href' => $this->url->link('common/dashboard', 'token=' . $data['token'], true)
        );
        $data['breadcrumbs'][] = array(
            'text' => $this->language->get('heading_title'),
            'href' => $this->url->link('report/sale_analytics', 'token=' . $data['token'] . $url, true)
        );

        /** Categories list */
        $this->load->model('catalog/category');
        $filter_data = array(
            'sort'        => 'name',
            'order'       => 'ASC'
        );
        $data['categories'] = $this->model_catalog_category->getCategories($filter_data);

        /** Order_statuses */
        $this->load->model('localisation/order_status');
        $data['order_statuses'] = $this->model_localisation_order_status->getOrderStatuses();

        /** Texts */
        $data['heading_title'] = $this->language->get('heading_title');

        $data['text_wait_rebuild'] = '';

        if ($sale_analytics_status == 1) {
            $query = $this->model_report_sale_analytics->getQuerySelectedOrders();
            $time = $query->num_rows * 2;

            if ($time > 0) {
                $hours = floor($time / 60);
                $minutes = $time % 60;

                $data['text_wait_rebuild'] = sprintf($this->language->get('text_wait_rebuild'), $hours, $minutes);
            }
        } else {
            $data['text_wait_rebuild'] = $this->language->get('text_no_rebuild');
        }

        $data['text_list'] = $this->language->get('text_list');
        $data['text_no_results'] = $this->language->get('text_no_results');
        $data['text_confirm'] = $this->language->get('text_confirm');
        $data['text_pieces'] = $this->language->get('text_pieces');
        $data['text_days'] = $this->language->get('text_days');
        $data['text_order'] = $this->language->get('text_order');

        $data['column_image'] = $this->language->get('column_image');
        $data['column_name'] = $this->language->get('column_name');
        $data['column_quantity'] = $this->language->get('column_quantity');
        $data['column_add'] = $this->language->get('column_add');
        $data['column_remove'] = $this->language->get('column_remove');
        $data['column_days_left'] = $this->language->get('column_days_left');
        $data['column_quantity_average'] = $this->language->get('column_quantity_average');
        $data['column_total_price'] = sprintf($this->language->get('column_total_price'), $data['periodDays']);

        $data['entry_name'] = $this->language->get('entry_name');
        $data['entry_model'] = $this->language->get('entry_model');
        $data['entry_cathegory'] = $this->language->get('entry_cathegory');
        $data['entry_select_cathegory'] = $this->language->get('entry_select_cathegory');
        $data['entry_cathegory'] = $this->language->get('entry_cathegory');
        $data['entry_date_start'] = $this->language->get('entry_date_start');
        $data['entry_date_end'] = $this->language->get('entry_date_end');

        $data['button_filter'] = $this->language->get('button_filter');
        $data['button_config'] = $this->language->get('button_config');

        $data['config'] = $this->url->link('extension/module/sale_analytics', 'token=' . $data['token'] . '&type=module', true);

        /** Blocks */
        $data['header'] = $this->load->controller('common/header');
        $data['column_left'] = $this->load->controller('common/column_left');
        $data['footer'] = $this->load->controller('common/footer');

        $this->response->setOutput($this->load->view('report/sale_analytics', $data));
    }
}
