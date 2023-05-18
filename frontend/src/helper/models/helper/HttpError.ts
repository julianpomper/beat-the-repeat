import { deleteSession } from "../../cookie";
import { goto } from '$app/navigation';

export class HttpError extends Error {
    constructor(
        message: string,
        public readonly status: number,
    ) {
        super(message);
    }
}

export function handleHttpError(error: HttpError) {
    if (error instanceof HttpError) {
        if (error.status == 401) {
            deleteSession();
            goto("/");
        }
    }
}