export interface Image {
    id:             number;
    name:           string;
    original_name:  string;
    url:            string;
    thumbnail_url:  string;
    mime_type:      string;
    extension:      string;
    size:           number;
    size_human:     string;
    width:          number;
    height:         number;
    exif_stripped:  boolean;
    is_private:     boolean;
    caption?:       string;
    alt_text?:      string;
    tags?:          Tag[];
    notes?:         ImageNote[];
    reactions?:     Record<string, number>;
    user_reaction?: string | null;
    versions?:      ImageVersion[];
    uploaded_by?:   import('./index').User;
    shared_links?:  import('./index').SharedLink[];
    created_at:     string;
    updated_at:     string;
}

export interface Tag {
    id:         number;
    name:       string;
    slug:       string;
    created_at: string;
}

export interface ImageNote {
    id:         number;
    body:       string;
    created_at: string;
    user:       {
        id:     number;
        name:   string;
        avatar: string | null;
    };
}

export interface ImageVersion {
    id:             number;
    version_number: number;
    url:            string;
    thumbnail_url:  string;
    size:           number;
    size_human:     string;
    width:          number;
    height:         number;
    label:          string | null;
    change_note:    string | null;
    created_at:     string;
}

export interface ImageReaction {
    id:         number;
    emoji:      string;
    user?:      {
        id:     number;
        name:   string;
    };
    created_at: string;
}

export interface ImagePoll {
    id:           number;
    question:     string;
    public_token: string;
    public_url:   string;
    image_a:      Image;
    image_b:      Image;
    results:      {
        total:     number;
        a_count:   number;
        b_count:   number;
        a_percent: number;
        b_percent: number;
    };
    has_voted:    boolean;
    user_vote:    'a' | 'b' | null;
    created_at:   string;
}

export interface SharedLink {
    id:                     number;
    token:                  string;
    url:                    string;
    image?:                 Image;
    created_by?:            import('./index').User;
    is_password_protected:  boolean;
    is_expired:             boolean;
    expires_at:             string | null;
    expires_in_human:       string | null;
    view_count:             number;
    created_at:             string;
}

export type ImageSortOption = 'latest' | 'oldest' | 'largest' | 'smallest' | 'name';
export type ImageViewMode   = 'grid' | 'list';
export type ImageGridSize   = 'sm' | 'md' | 'lg';

export interface ImageFilters {
    search?: string;
    sort?:   ImageSortOption;
    page?:   number;
}

export interface PaginatedImages {
    data:  Image[];
    meta:  PaginationMeta;
    links: PaginationLinks;
}

export interface PaginationMeta {
    current_page: number;
    last_page:    number;
    per_page:     number;
    total:        number;
    from:         number | null;
    to:           number | null;
}

export interface PaginationLinks {
    first: string | null;
    last:  string | null;
    prev:  string | null;
    next:  string | null;
}