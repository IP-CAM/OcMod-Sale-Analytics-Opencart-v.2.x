<?php echo $header; ?><?php echo $column_left; ?>
<div id="content">
    <div class="page-header">
        <div class="container-fluid">
            <div class="pull-right">
                <button type="submit" form="form-category" data-toggle="tooltip" title="" class="btn btn-primary"
                    data-original-title="<?php echo $button_save; ?>">
                    <i class="fa fa-save"></i>
                </button>
                <a href="<?php echo $cancel; ?>" data-toggle="tooltip" title="" class="btn btn-default"
                    data-original-title="<?php echo $button_cancel; ?>">
                    <i class="fa fa-reply"></i>
                </a>
            </div>
            <h1><?php echo $heading_title_config; ?></h1>
            <ul class="breadcrumb">
                <?php foreach ($breadcrumbs as $breadcrumb) { ?>
                <li>
                    <a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a>
                </li>
                <?php } ?>
            </ul>
        </div>
    </div>
    <div class="container-fluid">
        <div class="alert alert-danger">
            <i class="fa fa-exclamation-circle"></i>
            <?php echo $text_warning_rebuild; ?>
        </div>
        <?php if ($error_warning) { ?>
        <div class="alert alert-danger">
            <i class="fa fa-exclamation-circle"></i>
            <?php echo $error_warning; ?>
            <button type="button" class="close" data-dismiss="alert">&times;</button>
        </div>
        <?php }  ?>
        <div class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title">
                    <i class="fa fa-pencil"></i>
                    <?php echo $text_form_config; ?></h3>
            </div>
            <div class="panel-body">
                <form action="<?php echo $action; ?>" method="post" enctype="multipart/form-data" id="form-attribute"
                    class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-2 control-label"
                            for="input-data-rebuild"><?php echo $entry_data_rebuild; ?></label>
                        <div class="col-sm-10">
                            <div class="input-group date">
                                <input type="text" name="sale_analytics_data_rebuild"
                                    value="<?php echo $sale_analytics_data_rebuild; ?>"
                                    placeholder="<?php echo $entry_data_rebuild; ?>" data-date-format="YYYY-MM-DD"
                                    id="input-data-rebuild" class="form-control" />
                                <span class="input-group-btn">
                                    <button type="button" class="btn btn-default">
                                        <i class="fa fa-calendar"></i>
                                    </button>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label"
                            for="input-order-status"><?php echo $entry_order_status; ?></label>
                        <div class="col-sm-10">
                            <select name="sale_analytics_order_status" id="input-order-status" class="form-control">
                                <?php if ($sale_analytics_order_status == '0') { ?>
                                <option value="0" selected="selected"><?php echo $text_missing; ?></option>
                                <?php } else { ?>
                                <option value="0"><?php echo $text_missing; ?></option>
                                <?php } ?>
                                <?php foreach ($order_statuses as $order_status) { ?>
                                <?php if ($order_status['order_status_id'] == $sale_analytics_order_status) { ?>
                                <option value="<?php echo $order_status['order_status_id']; ?>" selected="selected">
                                    <?php echo $order_status['name']; ?></option>
                                <?php } else { ?>
                                <option value="<?php echo $order_status['order_status_id']; ?>">
                                    <?php echo $order_status['name']; ?></option>
                                <?php } ?>
                                <?php } ?>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label" for="input-status"><?php echo $entry_rebuild; ?></label>
                        <div class="col-sm-10">
                            <select name="sale_analytics_status" id="input-status" class="form-control">
                                <?php if ($sale_analytics_status) { ?>
                                <option value="1" selected="selected"><?php echo $text_enabled; ?></option>
                                <option value="0"><?php echo $text_disabled; ?></option>
                                <?php } else { ?>
                                <option value="1"><?php echo $text_enabled; ?></option>
                                <option value="0" selected="selected"><?php echo $text_disabled; ?></option>
                                <?php } ?>
                            </select>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        <!--
        $('.date').datetimepicker({
            pickTime: false
        });
        -->
    </script>
</div>
<?php echo $footer; ?>