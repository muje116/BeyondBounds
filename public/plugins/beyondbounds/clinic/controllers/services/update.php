<?php if (!$this->fatalError): ?>
    <?= Form::open(['class' => 'layout']) ?>
        <div class="layout-row">
            <?= $this->formRender() ?>
        </div>
        <div class="form-buttons">
            <?= Ui::ajaxButton(label: __('Save'), handler: 'onSave', primary: true, hotkey: ['ctrl+s', 'cmd+s']) ?>
            <?= Ui::ajaxButton(label: __('Save & Close'), handler: 'onSave', secondary: true, dataRequestData: 'close: true') ?>
            <?= Ui::iconButton(label: __('Delete'), icon: 'oc-icon-delete', handler: 'onDelete', danger: true, class: 'pull-right', dataRequestConfirm: __('Are you sure?')) ?>
        </div>
    <?= Form::close() ?>
<?php else: ?>
    <p class="flash-message static error"><?= e($this->fatalError) ?></p>
<?php endif ?>
