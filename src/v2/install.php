<?php
$this->load->model('user/user_group');
$this->model_user_user_group->addPermission($this->user->getId(), 'access', 'module/sale_analytics');
$this->model_user_user_group->addPermission($this->user->getId(), 'modify', 'module/sale_analytics');
