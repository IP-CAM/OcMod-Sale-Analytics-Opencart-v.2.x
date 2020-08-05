<?php echo $header; ?><?php echo $column_left; ?>
<div id="content">
    <div class="page-header">
        <div class="container-fluid">
            <div class="pull-right">
                <a href="<?php echo $config; ?>" data-toggle="tooltip" title="" class="btn btn-info"
                    data-original-title="<?php echo $button_config; ?>">
                    <i class="fa fa-cog"></i>
                </a>
            </div>
            <h1><?php echo $heading_title; ?></h1>
            <ul class="breadcrumb">
                <?php foreach ($breadcrumbs as $breadcrumb) { ?>
                <li>
                    <a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a>
                </li>
                <?php } ?>
            </ul>
        </div>
    </div>
    <div id="app" class="container-fluid">
        <?php if ($text_wait_rebuild) { ?>
        <div class="alert alert-danger">
            <i class="fa fa-exclamation-circle"></i>
            <?php echo $text_wait_rebuild; ?>
        </div>
        <?php } else { ?>
        <div class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title">
                    <i class="fa fa-bar-chart"></i>
                    <?php echo $text_list; ?></h3>
            </div>
            <div class="panel-body">
                <div class="well">
                    <div class="row">
                        <div class="col-sm-6">
                            <div class="form-group">
                                <label class="control-label" for="input-name"><?php echo $entry_name; ?></label>
                                <input type="text" name="filter_name" value="<?php echo $filter_name; ?>"
                                    placeholder="<?php echo $entry_name; ?>" id="input-name" class="form-control" />
                            </div>
                            <div class="form-group">
                                <label class="control-label" for="input-model"><?php echo $entry_model; ?></label>
                                <input type="text" name="filter_model" value="<?php echo $filter_model; ?>"
                                    placeholder="<?php echo $entry_model; ?>" id="input-model" class="form-control" />
                            </div>
                            <div class="form-group">
                                <label class="control-label"
                                    for="input-category"><?php echo $entry_cathegory; ?></label>
                                <select name="filter_category" id="input-category" class="form-control">
                                    <option value="0"><?php echo $entry_select_cathegory ?></option>
                                    <?php foreach ($categories as $category) { ?>
                                    <?php if ($category['product_count'] >= 1) { ?>
                                    <?php if ($category['category_id']==$filter_category) { ?>
                                    <option value="<?php echo $category['category_id']; ?>" selected="selected">
                                        <?php echo $category['name']; ?>&nbsp;&nbsp;&nbsp;&nbsp;</option>
                                    <?php } else { ?>
                                    <option value="<?php echo $category['category_id']; ?>">
                                        &nbsp;&nbsp;<?php echo $category['name']; ?>&nbsp;&nbsp;&nbsp;&nbsp;</option>
                                    <?php } ?>
                                    <?php } ?>
                                    <?php } ?>
                                </select>
                            </div>
                        </div>
                        <div class="col-sm-6">
                            <div class="form-group">
                                <label class="control-label"
                                    for="input-order-status"><?php echo $entry_order_status; ?></label>
                                <select name="filter_order_status" id="input-order-status" class="form-control">
                                    <?php if ($filter_order_status == '0') { ?>
                                    <option value="0" selected="selected"><?php echo $text_missing; ?></option>
                                    <?php } else { ?>
                                    <option value="0"><?php echo $text_missing; ?></option>
                                    <?php } ?>
                                    <?php foreach ($order_statuses as $order_status) { ?>
                                    <?php if ($order_status['order_status_id'] == $filter_order_status) { ?>
                                    <option value="<?php echo $order_status['order_status_id']; ?>" selected="selected">
                                        <?php echo $order_status['name']; ?></option>
                                    <?php } else { ?>
                                    <option value="<?php echo $order_status['order_status_id']; ?>">
                                        <?php echo $order_status['name']; ?></option>
                                    <?php } ?>
                                    <?php } ?>
                                </select>
                            </div>
                            <div class="form-group">
                                <label class="control-label"
                                    for="input-date-start"><?php echo $entry_date_start; ?></label>
                                <div class="input-group date">
                                    <input type="text" name="filter_date_start"
                                        value="<?php echo $filter_date_start; ?>"
                                        placeholder="<?php echo $entry_date_start; ?>" data-date-format="YYYY-MM-DD"
                                        id="input-date-start" class="form-control" />
                                    <span class="input-group-btn">
                                        <button type="button" class="btn btn-default">
                                            <i class="fa fa-calendar"></i>
                                        </button>
                                    </span>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label" for="input-date-end"><?php echo $entry_date_end; ?></label>
                                <div class="input-group date">
                                    <input type="text" name="filter_date_end" value="<?php echo $filter_date_end; ?>"
                                        placeholder="<?php echo $entry_date_end; ?>" data-date-format="YYYY-MM-DD"
                                        id="input-date-end" class="form-control" />
                                    <span class="input-group-btn">
                                        <button type="button" class="btn btn-default">
                                            <i class="fa fa-calendar"></i>
                                        </button>
                                    </span>
                                </div>
                            </div>
                            <button type="button" id="button-filter" class="btn btn-primary pull-right">
                                <i class="fa fa-filter"></i>
                                <?php echo $button_filter; ?></button>
                        </div>
                    </div>
                </div>

                <div class="row" style="margin-bottom: 15px;">
                    <div class="col-sm-6 text-left">
                        <component-pagination></component-pagination>
                    </div>
                    <div class="col-sm-6 text-right">
                        <div class="input-group input-group-sm" style="width: 180px; float: right;">
                            <label class="input-group-addon" for="input-limit">Показывать:</label>
                            <select id="input-limit" class="form-control" @change="changeLimit">
                                <option value="15" selected="selected">15</option>
                                <option value="25">25</option>
                                <option value="50">50</option>
                                <option value="75">75</option>
                                <option value="100">100</option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="table-responsive">
                    <!-- TABLE -->
                    <table class="table table-bordered table-striped">
                        <thead>
                            <tr>
                                <th class="text-left"><?php echo $column_image; ?></th>
                                <th class="text-left"><?php echo $column_name; ?></th>
                                <th class="text-left sortable quantity" v-on:click="sortByCol">
                                    <?php echo $column_quantity; ?></th>
                                <!-- <th class="text-left"><?php echo $column_add; ?></th> -->
                                <th class="text-left"><?php echo $column_remove; ?></th>
                                <th class="text-left sortable days-left" v-on:click="sortByCol">
                                    <?php echo $column_days_left; ?></th>
                                <th class="text-left sortable quantity-average" v-on:click="sortByCol">
                                    <?php echo $column_quantity_average; ?></th>
                                <th class="text-left sortable total-price" v-on:click="sortByCol">
                                    <?php echo $column_total_price; ?></th>
                            </tr>
                        </thead>

                        <tbody>
                            <tr v-if="checkResult" v-for="row in prepareResult" :key="row">
                                <td class="text-center image zoom-wrap" v-html="row.image"></td>
                                <td class="text-left name" v-html="row.name"></td>
                                <td class="text-center quantity">{{ row.q_total }} <?php echo $text_pieces ?></td>
                                </td>
                                <!-- <td class="text-center add"></td> -->
                                <td class="text-center remove">
                                    <div class="bubble-wrap">
                                        <ul class="buble" :class="{ more: row.q_remove.length > 1 }"
                                            @click.self="toggleOrders">
                                            <li v-for="order in row.q_remove" :key="order" v-html="order.html"></li>
                                        </ul>
                                    </div>
                                </td>
                                <td class="text-center days-left">{{ row.days_left }} <?php echo $text_days ?></td>
                                <td class="text-center quantity-average">{{ row.q_average }}</td>
                                <td class="text-center total-price">{{ row.total_price.toFixed(4) }}</td>
                            </tr>
                            <tr v-if="!checkResult">
                                <td colspan="7" class="text-center"><?php echo $text_no_results ?></td>
                            </tr>
                        </tbody>
                    </table>

                </div>

                <div class="row">
                    <div class="col-sm-6 text-left">
                        <component-pagination></component-pagination>
                    </div>
                </div>
            </div>
        </div>
        <?php }  ?>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/vue@2.6.11"></script>
    <script src="https://cdn.jsdelivr.net/npm/es6-promise@4/dist/es6-promise.auto.js"></script>
    <script src="https://unpkg.com/vuex@3.5.1/dist/vuex.js"></script>

    <script type="text/javascript">
        Vue.use(Vuex)

        const store = new Vuex.Store({
            state: {
                filterResult: [],
                limitPagination: 15,
                currentPage: 1,
            },
            mutations: {
                addFilterResult(state, obj) {
                    state.filterResult = obj;
                }
            }
        })

        store.commit('addFilterResult', JSON.parse('<?= $filter_result ?>'));
        //console.log(store.state.filterResult.length);

        const componentPagination = {
            /* data() {
                return {
                    currentPage: store.state.currentPage,
                }
            }, */
            template: `<ul class="pagination">
                <li :class="[ (page.value == store.state.currentPage) ? 'active' : '' ]" v-for="page in pagesList"
                    :key="page">
                    <span v-if="page.value == store.state.currentPage" v-html="page.name"></span>
                    <a v-if="page.value != store.state.currentPage" href="#" :data-target="page.value"
                        @click.prevent="changePage"
                        v-html="page.name"></a>
                </li>
            </ul>`,
            methods: {
                changePage: function (event) {
                    const el = event.target;
                    store.state.currentPage = el.dataset.target;
                }
            },
            computed: {
                pagesList: function () {
                    const currentPage = +store.state.currentPage;
                    const filterResultLength = store.state.filterResult.length;
                    let prevPage = 0;
                    let nextPage = 0;
                    const cntPages = Math.ceil(filterResultLength / store.state.limitPagination);

                    let pages = []

                    if (cntPages <= 10) {
                        for (let i = 1; i <= cntPages; i++) {
                            pages.push({
                                value: i,
                                name: i
                            });
                        }
                    } else {
                        if (currentPage <= 5) {
                            for (let i = 1; i <= 9; i++) {
                                pages.push({
                                    value: i,
                                    name: i
                                });
                            }
                            nextPage = 10;
                        }
                        if (currentPage > 5) {
                            if (currentPage <= (cntPages - 5)) {
                                prevPage = currentPage - 3;
                            } else {
                                prevPage = cntPages - 6;
                            }

                            pages.push({
                                value: 1,
                                name: '|&lt;'
                            });
                            pages.push({
                                value: prevPage,
                                name: '&lt;'
                            });

                            if (currentPage <= (cntPages - 5)) {
                                for (let i = currentPage - 2; i <= currentPage + 2; i++) {
                                    pages.push({
                                        value: i,
                                        name: i
                                    });
                                }
                                nextPage = currentPage + 3;
                            } else {
                                for (let i = cntPages - 5; i <= cntPages; i++) {
                                    pages.push({
                                        value: i,
                                        name: i
                                    });
                                }
                            }
                        }

                        if (currentPage <= (cntPages - 5)) {
                            pages.push({
                                value: nextPage,
                                name: '&gt;'
                            });
                            pages.push({
                                value: cntPages,
                                name: '&gt;|'
                            });
                        }
                    }

                    return pages;
                },
            },
        }

        var app = new Vue({
            el: '#app',
            data: {
                periodDays: parseInt('<?php echo $periodDays; ?>'),
                sortField: '',
                sortDirection: '',
                checkResult: store.state.filterResult.length > 0,
            },
            components: {
                componentPagination
            },
            computed: {
                prepareResult: function () {
                    const row = JSON.parse(JSON.stringify(store.state.filterResult));
                    let prepareRow = [];
                    const minKey = ((store.state.currentPage - 1) * store.state.limitPagination);
                    let maxKey = (store.state.currentPage * store.state.limitPagination);
                    maxKey = maxKey <= row.length ? maxKey : row.length;
                    let i = 0;

                    //for (let key = minKey; key < maxKey; key++) {
                    for (let key = 0; key < row.length; key++) {
                        prepareRow.push(row[key]);

                        /** Total remove */
                        const qRemove = row[key].q_remove;
                        let totalRemove = 0;
                        for (let k in qRemove) {
                            totalRemove += +qRemove[k].value;

                            prepareRow[i].q_remove[k].html = qRemove[k].order_date + ' ' +
                                qRemove[k].value +
                                '<?php echo $text_pieces ?> <?php echo $text_order ?> <a href="' + qRemove[
                                    k].order_link + '" target="_blank">#' + qRemove[k].order_id + '</a>';
                        }
                        prepareRow[i].q_remove.unshift({
                            html: totalRemove + ' <?php echo $text_pieces ?>'
                        });
                        prepareRow[i].total_remove = totalRemove;

                        /** Image */
                        if (row[key].image != null) {
                            prepareRow[i].image = '<img src="' + row[key].image + '" alt="' +
                                row[key].name + '" class="img-thumbnail show-zoom" data-imgfull="' +
                                row[key].image_full + '"><div class="zoom-pop"><img src="' +
                                row[key].image_big + '" alt="' + row[key].name + '"/></div>';
                        } else {
                            prepareRow[i].image =
                                '<span class="img-thumbnail list"><i class="fa fa-camera fa-2x"></i></span>';
                        }

                        prepareRow[i].name = '<a href="' + row[key].url_product_edit +
                            '" target="_blank">' + row[key].name + '</a>';

                        const q_average = totalRemove / this.periodDays;
                        prepareRow[i].q_average = Math.round(q_average * 100) / 100;

                        const days_left = +row[key].q_total == 0 ?
                            0 :
                            row[key].q_total / row[key].q_average;
                        prepareRow[i].days_left = Math.round(days_left * 100) / 100;
                        prepareRow[i].q_total = +row[key].q_total;

                        i++;
                    }

                    /** Sort row */
                    if (this.sortField != '') {
                        prepareRow = prepareRow.sort(this.sortData);
                    }

                    prepareRow.splice(maxKey, (prepareRow.length - maxKey));
                    if (minKey > 0) {
                        prepareRow.splice(0, minKey);
                    }
                    prepareRow.splice()

                    return prepareRow;
                }
            },
            methods: {
                toggleOrders: function (event) {
                    const el = event.target;

                    if (el.classList.contains('more')) {
                        el.classList.toggle('open');
                        el.querySelectorAll('li').forEach(function (elLi) {
                            elLi.classList.toggle('open')
                        });
                    }
                },
                sortByCol: function (event) {
                    const el = event.target;

                    /** Sort switch */
                    if (el.classList.contains('quantity')) {
                        this.sortField = 'q_total';
                    }
                    if (el.classList.contains('days-left')) {
                        this.sortField = 'days_left';
                    }
                    if (el.classList.contains('quantity-average')) {
                        this.sortField = 'q_average';
                    }
                    if (el.classList.contains('total-price')) {
                        this.sortField = 'total_price';
                    }

                    /** Toggle element class */
                    if (el.classList.contains('sort-up')) {
                        this.sortDirection = 'dwn';
                        this.clearClassSort();

                        el
                            .classList
                            .add('sort-dwn');
                    } else if (el.classList.contains('sort-dwn')) {
                        this.sortField = '';
                        this.sortDirection = '';
                        this.clearClassSort();

                    } else {
                        this.sortDirection += 'up';
                        this.clearClassSort();

                        el
                            .classList
                            .add('sort-up');
                    }
                },
                clearClassSort: function () {
                    const allTh = document.querySelectorAll('.sortable');
                    allTh.forEach(function (el) {
                        el
                            .classList
                            .remove('sort-up', 'sort-dwn');
                    })
                },
                sortData: function (a, b) {
                    const field = this.sortField;

                    if (this.sortDirection == 'dwn') {
                        b = [a, a = b][0];
                    }

                    return (a[field] > b[field]) ?
                        1 :
                        -1;
                },
                changeLimit: function (event) {
                    const el = event.target;
                    store.state.limitPagination = el.value;
                    store.state.currentPage = 1;
                },
            },
        });
    </script>

    <style>
        .sortable {
            position: relative;
            cursor: pointer;
            padding-right: 20px !important;
        }

        .sortable::after,
        .sortable::before {
            position: absolute;
            right: 5px;
            top: 50%;
            font: normal normal normal 14px/1 FontAwesome;
            font-size: 12px;
            line-height: 12px;
        }

        .sortable::after {
            content: "\f063";
            margin-bottom: -15px;
            color: #ccc;
        }

        .sortable::before {
            content: "\f062";
            margin-top: -15px;
            color: #ccc;
        }

        /** */
        .sortable.sort-dwn,
        .sortable.sort-up {
            background: #1e91cf;
            color: #fff;
        }

        .sortable.sort-dwn::after,
        .sortable.sort-up::before {
            color: #fff;
        }

        .sortable.sort-dwn::before,
        .sortable.sort-up::after {
            color: #1978ab;
        }

        /** */
        .buble {
            position: relative;
            width: 100%;
            padding: 0;
            margin: 0;
            list-style: none;
        }

        .buble.more::after {
            content: "\f063";
            position: absolute;
            top: -5px;
            right: -5px;
            width: 30px;
            height: 30px;
            font: normal normal normal 14px/1 FontAwesome;
            font-size: 12px;
            line-height: 30px;
            color: #ccc;
            cursor: pointer;
        }

        .buble.more:hover::after {
            color: #1978ab;
        }

        .buble.more.open::after {
            content: "\f062";
            color: #1978ab;

        }

        .buble li {
            height: 0;
            padding: 0 25px 0 5px;
            font-size: 0px;
            line-height: 0px;
            white-space: nowrap;
            transition: all 0.5s ease;
        }

        .buble li.open,
        .buble li:first-child {
            height: 20px;
            font-size: 12px;
            line-height: 20px;
        }
    </style>

    <script type="text/javascript">
        $('#button-filter').on('click', function () {
            url = 'index.php?route=report/sale_analytics&token=<?php echo $token; ?>';

            var filter_name = $('input[name=\'filter_name\']').val();

            if (filter_name) {
                url += '&filter_name=' + encodeURIComponent(filter_name);
            }

            var filter_model = $('input[name=\'filter_model\']').val();

            if (filter_model) {
                url += '&filter_model=' + encodeURIComponent(filter_model);
            }

            var filter_category = $('select[name=\'filter_category\']').val();

            if (filter_category != '*') {
                url += '&filter_category=' + encodeURIComponent(filter_category);
            }

            var filter_order_status = $('select[name=\'filter_order_status\']').val();

            if (filter_order_status != '*') {
                url += '&filter_order_status=' + encodeURIComponent(filter_order_status);
            }

            var filter_date_start = $('input[name=\'filter_date_start\']').val();

            if (filter_date_start) {
                url += '&filter_date_start=' + encodeURIComponent(filter_date_start);
            }

            var filter_date_end = $('input[name=\'filter_date_end\']').val();

            if (filter_date_end) {
                url += '&filter_date_end=' + encodeURIComponent(filter_date_end);
            }

            location = url;
        });
    </script>
    <script type="text/javascript">
        $('.date').datetimepicker({
            pickTime: false
        });

        // Увеличение картинки товара по ховеру
        $('.zoom-wrap').on('mouseover', '.show-zoom', function () {
            $(this)
                .parent('.zoom-wrap')
                .find('.zoom-pop')
                .show();
        });
        $('.zoom-wrap').on('mouseout', '.show-zoom', function () {
            $(this)
                .parent('.zoom-wrap')
                .find('.zoom-pop')
                .hide();
        });
        $('.zoom-wrap').on('click', '.show-zoom', function (e) {
            window.open($(e.target).data('imgfull'), '_blank');
        });
    </script>
    <script type="text/javascript">
        $('input[name=\'filter_name\']').autocomplete({
            'source': function (request, response) {
                $.ajax({
                    url: 'index.php?route=catalog/product/autocomplete&token=<?php echo $token; ?>&filter_name=' +
                        encodeURIComponent(request),
                    dataType: 'json',
                    success: function (json) {
                        response($.map(json, function (item) {
                            return {
                                label: item['name'],
                                value: item['product_id']
                            }
                        }));
                    }
                });
            },
            'select': function (item) {
                $('input[name=\'filter_name\']').val(item['label']);
            }
        });

        $('input[name=\'filter_model\']').autocomplete({
            'source': function (request, response) {
                $.ajax({
                    url: 'index.php?route=catalog/product/autocomplete&token=<?php echo $token; ?>&filter_model=' +
                        encodeURIComponent(request),
                    dataType: 'json',
                    success: function (json) {
                        response($.map(json, function (item) {
                            return {
                                label: item['model'],
                                value: item['product_id']
                            }
                        }));
                    }
                });
            },
            'select': function (item) {
                $('input[name=\'filter_model\']').val(item['label']);
            }
        });
    </script>
</div>
<?php echo $footer; ?>