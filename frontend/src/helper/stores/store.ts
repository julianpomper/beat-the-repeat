import { writable, Writable } from 'svelte/store';
import { User } from "../models/user";
import { Playlist } from "../models/playlist";

export const userStore: Writable<User | undefined> = writable(undefined);
export const playlistsStore: Writable<Playlist[]> = writable([]);
