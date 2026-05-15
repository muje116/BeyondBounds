<?php namespace BeyondBounds\Clinic\Components;

use Cms\Classes\ComponentBase;

class ViteAssets extends ComponentBase
{
    public function componentDetails()
    {
        return [
            'name' => 'Vite Assets',
            'description' => 'Provides built asset URLs from public/build/manifest.json.',
        ];
    }

    public function onRun()
    {
        $docRoot = (string) ($_SERVER['DOCUMENT_ROOT'] ?? '');
        $docRoot = rtrim(str_replace('\\', '/', $docRoot), '/');

        // Only use /build/* URLs when the web server is actually serving from /public.
        // October's CLI server can run with a different document root, which causes /build/* to return HTML.
        $publicPath = rtrim(str_replace('\\', '/', base_path('public')), '/');
        $canServeBuild = $docRoot !== '' && $publicPath !== '' && strcasecmp($docRoot, $publicPath) === 0;

        $manifestPath = base_path('public/build/manifest.json');
        $cssUrl = null;
        $jsUrl = null;

        if ($canServeBuild && is_file($manifestPath)) {
            $json = @file_get_contents($manifestPath);
            $manifest = $json ? @json_decode($json, true) : null;

            if (is_array($manifest)) {
                $css = $manifest['themes/beyondbounds/assets/css/app.css']['file'] ?? null;
                $js = $manifest['themes/beyondbounds/assets/js/app.js']['file'] ?? null;

                if ($css) {
                    $cssUrl = '/build/' . ltrim($css, '/');
                }
                if ($js) {
                    $jsUrl = '/build/' . ltrim($js, '/');
                }
            }
        }

        $this->page['viteCss'] = $cssUrl;
        $this->page['viteJs'] = $jsUrl;
    }
}

