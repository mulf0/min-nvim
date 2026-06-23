return {
    settings = {
        ['rust-analyzer'] = {
            checkOnSave = true,
            check = {
                command = 'clippy',
            },
            cargo = {
                features = 'all',
            },
            inlayHints = {
                bindingModeHints = { enable = true },
                closureCaptureHints = { enable = true },
                closureReturnTypeHints = { enable = 'always' },
                discriminantHints = { enable = 'always' },
                expressionAdjustmentHints = { enable = 'always' },
                lifetimeElisionHints = { enable = 'always' },
                parameterHints = { enable = true },
                typeHints = { enable = true },
            },
        },
    },
}
