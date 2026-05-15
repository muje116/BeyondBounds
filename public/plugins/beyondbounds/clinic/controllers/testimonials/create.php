<?php if (!$this->fatalError): ?>
    <?= Form::open(['class' => 'layout']) ?>
        <div class="layout-row"><?= $this->formRender() ?></div>
        <div class="form-buttons">
            <?= Ui::ajaxButton(label: __('Create'), handler: 'onSave', primary: true, hotkey: ['ctrl+s', 'cmd+s']) ?>
            <?= Ui::ajaxButton(label: __('Create & Close'), handler: 'onSave', secondary: true, dataRequestData: 'close: true') ?>
        </div>
    <?= Form::close() ?>
<?php else: ?><p class="flash-message static error"><?= e($this->fatalError) ?></p><?php endif ?>
