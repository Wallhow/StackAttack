//FIXED_AUTO
//FIXED_ZOOM
/** @noResolution */
declare module 'orthographic.camera' {
    function get_view(camera_id: number): hash | url | null;
    function get_viewport(camera_id: number): { x: number, y: number, w: number, h: number };
    function get_zoom(camera_id: hash | url | null): number;
    function set_zoom(camera_id: hash | url | null, zoom: number): void;
    function use_projector(camera_id: hash | url | null, projector_id: hash): void;
}