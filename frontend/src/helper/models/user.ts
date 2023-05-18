export class User {
    constructor(
        public readonly id: number,
        public readonly name: string,
        public readonly imageUrl?: string,
        public readonly isActive: boolean,
        public readonly activePlaylistId?: string,
    ) {
    }
}

export interface UserDto {
    id: number
    name: string
    image_url?: string
    is_active: boolean
    selected_playlist_id?: string
}
