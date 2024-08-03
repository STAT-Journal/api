/* eslint-disable */
import * as types from './graphql';
import { TypedDocumentNode as DocumentNode } from '@graphql-typed-document-node/core';

/**
 * Map of all GraphQL operations in the project.
 *
 * This map has several performance disadvantages:
 * 1. It is not tree-shakeable, so it will include all operations in the project.
 * 2. It is not minifiable, so the string of a GraphQL query will be multiple times inside the bundle.
 * 3. It does not support dead code elimination, so it will add unused operations.
 *
 * Therefore it is highly recommended to use the babel or swc plugin for production.
 */
const documents = {
    "mutation addAvatar($avatar: AvatarInput!) {\n  addAvatar(avatar: $avatar) {\n    avatar {\n      options\n      style\n    }\n  }\n}": types.AddAvatarDocument,
    "mutation exchangeRefreshForAccessToken($refreshToken: String!) {\n  exchangeRefreshForAccessToken(refreshToken: $refreshToken) {\n    token\n    claims {\n      sub\n      exp\n      iat\n    }\n  }\n}": types.ExchangeRefreshForAccessTokenDocument,
    "query listTextPosts {\n  listTextPosts {\n    body\n    insertedAt\n  }\n}": types.ListTextPostsDocument,
    "query listMoments {\n  listMoments {\n    type\n    insertedAt\n  }\n}": types.ListMomentsDocument,
    "mutation createMoment($type: MomentType!) {\n  createMoment(type: $type) {\n    insertedAt\n    type\n  }\n}": types.CreateMomentDocument,
    "mutation createTextPost($body: String!) {\n  createTextPost(body: $body) {\n    body\n  }\n}": types.CreateTextPostDocument,
    "mutation registerWithEmail($email: String!) {\n  register(email: $email)\n}": types.RegisterWithEmailDocument,
    "mutation renewRefreshToken($refreshToken: String!) {\n  renewRefreshToken(refreshToken: $refreshToken) {\n    token\n    claims {\n      sub\n      exp\n      iat\n    }\n  }\n}": types.RenewRefreshTokenDocument,
    "query myProfile {\n  me {\n    email\n    public {\n      avatar {\n        options\n        style\n      }\n      username\n    }\n  }\n}": types.MyProfileDocument,
    "mutation addUsername($username: String!) {\n  addUsername(username: $username) {\n    username\n  }\n}": types.AddUsernameDocument,
};

/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 *
 *
 * @example
 * ```ts
 * const query = graphql(`query GetUser($id: ID!) { user(id: $id) { name } }`);
 * ```
 *
 * The query argument is unknown!
 * Please regenerate the types.
 */
export function graphql(source: string): unknown;

/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "mutation addAvatar($avatar: AvatarInput!) {\n  addAvatar(avatar: $avatar) {\n    avatar {\n      options\n      style\n    }\n  }\n}"): (typeof documents)["mutation addAvatar($avatar: AvatarInput!) {\n  addAvatar(avatar: $avatar) {\n    avatar {\n      options\n      style\n    }\n  }\n}"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "mutation exchangeRefreshForAccessToken($refreshToken: String!) {\n  exchangeRefreshForAccessToken(refreshToken: $refreshToken) {\n    token\n    claims {\n      sub\n      exp\n      iat\n    }\n  }\n}"): (typeof documents)["mutation exchangeRefreshForAccessToken($refreshToken: String!) {\n  exchangeRefreshForAccessToken(refreshToken: $refreshToken) {\n    token\n    claims {\n      sub\n      exp\n      iat\n    }\n  }\n}"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "query listTextPosts {\n  listTextPosts {\n    body\n    insertedAt\n  }\n}"): (typeof documents)["query listTextPosts {\n  listTextPosts {\n    body\n    insertedAt\n  }\n}"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "query listMoments {\n  listMoments {\n    type\n    insertedAt\n  }\n}"): (typeof documents)["query listMoments {\n  listMoments {\n    type\n    insertedAt\n  }\n}"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "mutation createMoment($type: MomentType!) {\n  createMoment(type: $type) {\n    insertedAt\n    type\n  }\n}"): (typeof documents)["mutation createMoment($type: MomentType!) {\n  createMoment(type: $type) {\n    insertedAt\n    type\n  }\n}"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "mutation createTextPost($body: String!) {\n  createTextPost(body: $body) {\n    body\n  }\n}"): (typeof documents)["mutation createTextPost($body: String!) {\n  createTextPost(body: $body) {\n    body\n  }\n}"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "mutation registerWithEmail($email: String!) {\n  register(email: $email)\n}"): (typeof documents)["mutation registerWithEmail($email: String!) {\n  register(email: $email)\n}"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "mutation renewRefreshToken($refreshToken: String!) {\n  renewRefreshToken(refreshToken: $refreshToken) {\n    token\n    claims {\n      sub\n      exp\n      iat\n    }\n  }\n}"): (typeof documents)["mutation renewRefreshToken($refreshToken: String!) {\n  renewRefreshToken(refreshToken: $refreshToken) {\n    token\n    claims {\n      sub\n      exp\n      iat\n    }\n  }\n}"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "query myProfile {\n  me {\n    email\n    public {\n      avatar {\n        options\n        style\n      }\n      username\n    }\n  }\n}"): (typeof documents)["query myProfile {\n  me {\n    email\n    public {\n      avatar {\n        options\n        style\n      }\n      username\n    }\n  }\n}"];
/**
 * The graphql function is used to parse GraphQL queries into a document that can be used by GraphQL clients.
 */
export function graphql(source: "mutation addUsername($username: String!) {\n  addUsername(username: $username) {\n    username\n  }\n}"): (typeof documents)["mutation addUsername($username: String!) {\n  addUsername(username: $username) {\n    username\n  }\n}"];

export function graphql(source: string) {
  return (documents as any)[source] ?? {};
}

export type DocumentType<TDocumentNode extends DocumentNode<any, any>> = TDocumentNode extends DocumentNode<  infer TType,  any>  ? TType  : never;