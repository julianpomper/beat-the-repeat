export class Playlist {
    constructor(
        public readonly id: string,
        public readonly name: string,
    ) {
    }
}

export interface PlaylistDto {
    id: string
    name: string
}
