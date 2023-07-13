import { writable, type Writable } from 'svelte/store';
import type { User } from '../models/user';
import type { Playlist } from '../models/playlist';

export const userStore: Writable<User | undefined> = writable(undefined);
export const playlistsStore: Writable<Playlist[]> = writable([]);
