import { userStore } from "../stores/store";
import { getSession } from "../cookie";
import { User, UserDto } from "../models/user";
import { handleHttpError, HttpError } from "../models/helper/HttpError";
import { API_URL } from "../constants";

export function fetchUser(): Promise<User> {
    return fetch(
        API_URL + "/me",
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
            const userDto = data as UserDto;
            const user = new User(userDto.id, userDto.name, userDto.image_url, userDto.is_active, userDto.selected_playlist_id);
            userStore.set(user);
            return user;
        })
        .catch(error => {
            handleHttpError(error);
            console.error(error);
            return new User(-1, "", undefined, true, undefined);
        });
}

export function updateUser(active: boolean, playlistId: string) {
    fetch(
        API_URL + "/me",
        {
            method: "PUT",
            headers: {
                "Authorization": "Bearer " + getSession(),
                "Content-Type": "application/json",
            },
            body: JSON.stringify({
                "is_active": active,
                "selected_playlist_id": playlistId ?? null,
            }),
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
            const user = data as UserDto;
            userStore.set(new User(user.id, user.name, user.image_url, user.is_active, user.active_playlist_id));
        })
        .catch(error => {
            handleHttpError(error);
            console.error(error);
            return new User(-1, "", undefined);
        });
}
