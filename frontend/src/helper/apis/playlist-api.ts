import { getSession } from "../cookie";
import { Playlist, type PlaylistDto } from "../models/playlist";
import { playlistsStore } from "../stores/store";
import { handleHttpError, HttpError } from "../models/helper/HttpError";
import { API_URL } from "../constants";

export function fetchPlaylists(): Promise<Playlist[]> {
    return fetch(
        API_URL() + "/playlists",
        {
            headers: { Authorization: 'Bearer ' + getSession() }
        },
    )
        .then(response => {
            if (!response.ok) {
                throw new HttpError("Invalid response", response.status);
            } else {
                return response.json()
            }
        })
        .then(data => {
            const playlists = data.map(playlist => {
                const playlistDto = playlist as PlaylistDto
                return new Playlist(playlistDto.id, playlistDto.name);
            });
            playlistsStore.set(playlists);
            return playlists;
        })
        .catch(error => {
            handleHttpError(error);
            console.error(error);
            return [];
        });
}
