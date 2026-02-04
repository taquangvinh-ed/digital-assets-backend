CREATE TABLE cesium_entities (
    id                  BIGSERIAL PRIMARY KEY,
    
    -- Tên, mô tả, loại entity (point, model, label, billboard, polygon, polyline, ...)
    name                TEXT,
    description         TEXT,
    entity_type         TEXT NOT NULL CHECK (entity_type IN (
        'point', 'label', 'billboard', 'model', 'polygon', 'polyline', 
        'polyline_volume', 'rectangle', 'ellipse', 'cylinder', 'box', 
        'wall', 'corridor', 'path', 'other'
    )),  -- giúp filter nhanh
    
    -- Vị trí chính (hầu hết entity dùng position này)
    -- Dùng geography để tính khoảng cách dễ dàng hơn Cartesian3
    position_geo        geography(POINTZ, 4326),          -- lon, lat, height (WGS84)
    -- Hoặc dùng geometry nếu bạn thích Cartesian3 dạng x,y,z
    -- position_cartesian  geometry(PointZ, 4978),         -- EPSG:4978 (ECEF)
    
    -- Thuộc tính graphics (JSONB linh hoạt nhất)
    graphics            JSONB,          -- lưu toàn bộ graphics object {point: {...}, label: {...}, model: {...}}
    
    -- Một số trường riêng phổ biến để query nhanh (không bắt buộc, nhưng rất hữu ích)
    label_text          TEXT,
    model_uri           TEXT,           -- đường dẫn glb/gltf
    billboard_image     TEXT,           -- url hình ảnh billboard
    color               TEXT,           -- hex hoặc rgba, ví dụ '#FF0000FF'
    scale               NUMERIC,        -- scale chung (model, billboard, point size)
    
    -- Thời gian (nếu entity có availability hoặc thay đổi theo thời gian)
    availability_start  TIMESTAMPTZ,
    availability_end    TIMESTAMPTZ,
    
    -- Metadata tùy chỉnh (tags, category, owner, project, ...)
    tags                TEXT[],         -- array tags: ['aquaculture', 'shrimp', 'can_tho']
    properties          JSONB,          -- arbitrary key-value (custom data)
    
    -- Hệ thống
    created_at          TIMESTAMPTZ DEFAULT NOW(),
    updated_at          TIMESTAMPTZ DEFAULT NOW(),
    created_by          TEXT,           -- user id hoặc username
    is_active           BOOLEAN DEFAULT TRUE,
    
    -- Spatial index (rất quan trọng!)
    CONSTRAINT entities_position_check CHECK (ST_Z(position_geo) IS NOT NULL)
);

-- Index cực kỳ quan trọng
CREATE INDEX idx_entities_position_geo ON cesium_entities USING GIST (position_geo);
CREATE INDEX idx_entities_entity_type ON cesium_entities (entity_type);
CREATE INDEX idx_entities_model_uri ON cesium_entities (model_uri);
CREATE INDEX idx_entities_tags ON cesium_entities USING GIN (tags);
CREATE INDEX idx_entities_properties ON cesium_entities USING GIN (properties);