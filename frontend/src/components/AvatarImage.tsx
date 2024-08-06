import * as collection from "@dicebear/collection";
import { Avatar } from "../gql/codegen/graphql";
import { toPng } from "@dicebear/converter";
import { createAvatar, Style } from "@dicebear/core";

const defaultOptions = {
    seed: "default",
}

const defaultStyle = collection.initials as Style<{ seed: string; }>;

function snakeCaseToCamelCase(snakeCase: string) {
    return snakeCase.replace(/-[a-z]/g, (letter) => `${letter[1].toUpperCase()}`);
}

export const getAvatarImageUri = (avatar: Avatar) => {
    const options = avatar?.options?JSON.parse(avatar?.options) : defaultOptions;
    const styleName = snakeCaseToCamelCase(avatar?.style?? "");
    const style = collection[styleName as keyof typeof collection] as Style<{ seed: string; }> || defaultStyle;

    const createdAvatar = createAvatar(style, options);
    return toPng(createdAvatar).toDataUri();
}