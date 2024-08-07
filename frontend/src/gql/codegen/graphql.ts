/* eslint-disable */
import { TypedDocumentNode as DocumentNode } from '@graphql-typed-document-node/core';
export type Maybe<T> = T | null;
export type InputMaybe<T> = Maybe<T>;
export type Exact<T extends { [key: string]: unknown }> = { [K in keyof T]: T[K] };
export type MakeOptional<T, K extends keyof T> = Omit<T, K> & { [SubKey in K]?: Maybe<T[SubKey]> };
export type MakeMaybe<T, K extends keyof T> = Omit<T, K> & { [SubKey in K]: Maybe<T[SubKey]> };
export type MakeEmpty<T extends { [key: string]: unknown }, K extends keyof T> = { [_ in K]?: never };
export type Incremental<T> = T | { [P in keyof T]?: P extends ' $fragmentName' | '__typename' ? T[P] : never };
/** All built-in and custom scalars, mapped to their actual values */
export type Scalars = {
  ID: { input: string; output: string; }
  String: { input: string; output: string; }
  Boolean: { input: boolean; output: boolean; }
  Int: { input: number; output: number; }
  Float: { input: number; output: number; }
};

export type AuthBlob = {
  __typename?: 'AuthBlob';
  claims: Claims;
  token: Scalars['String']['output'];
};

export type Avatar = {
  __typename?: 'Avatar';
  options?: Maybe<Scalars['String']['output']>;
  style?: Maybe<Scalars['String']['output']>;
};

export type AvatarInput = {
  options: Scalars['String']['input'];
  style: Scalars['String']['input'];
};

export type Claims = {
  __typename?: 'Claims';
  exp: Scalars['Int']['output'];
  iat: Scalars['Int']['output'];
  sub: Scalars['String']['output'];
};

export type Follow = {
  __typename?: 'Follow';
  followee: PublicUser;
  follower: PublicUser;
};

export type Moment = {
  __typename?: 'Moment';
  insertedAt: Scalars['String']['output'];
  type: MomentType;
};

export type MomentGraphItem = {
  __typename?: 'MomentGraphItem';
  bad?: Maybe<Scalars['Int']['output']>;
  good?: Maybe<Scalars['Int']['output']>;
  insertedAt: Scalars['String']['output'];
};

export enum MomentType {
  Bad = 'BAD',
  Good = 'GOOD'
}

export type MosaicInstance = {
  __typename?: 'MosaicInstance';
  createdAt?: Maybe<Scalars['String']['output']>;
  id?: Maybe<Scalars['Int']['output']>;
};

export type Presence = {
  numberOfEngagements?: InputMaybe<Scalars['Int']['input']>;
};

export type PrivateUser = {
  __typename?: 'PrivateUser';
  email: Scalars['String']['output'];
  public: PublicUser;
};

export type PublicUser = {
  __typename?: 'PublicUser';
  avatar?: Maybe<Avatar>;
  username?: Maybe<Scalars['String']['output']>;
};

export type RootMutationType = {
  __typename?: 'RootMutationType';
  addAvatar?: Maybe<PublicUser>;
  addUsername?: Maybe<PublicUser>;
  createFollow?: Maybe<Follow>;
  createMoment?: Maybe<Moment>;
  createPrescence: Scalars['String']['output'];
  createTextPost?: Maybe<TextPost>;
  createWeeklyCheckin?: Maybe<WeeklyCheckIn>;
  exchangeRefreshForAccessToken?: Maybe<AuthBlob>;
  participateInMosaic?: Maybe<Scalars['Int']['output']>;
  register?: Maybe<Scalars['String']['output']>;
  renewRefreshToken?: Maybe<AuthBlob>;
};


export type RootMutationTypeAddAvatarArgs = {
  avatar: AvatarInput;
};


export type RootMutationTypeAddUsernameArgs = {
  username: Scalars['String']['input'];
};


export type RootMutationTypeCreateFollowArgs = {
  followToken: Scalars['String']['input'];
};


export type RootMutationTypeCreateMomentArgs = {
  type: MomentType;
};


export type RootMutationTypeCreatePrescenceArgs = {
  presence: Presence;
};


export type RootMutationTypeCreateTextPostArgs = {
  body: Scalars['String']['input'];
};


export type RootMutationTypeCreateWeeklyCheckinArgs = {
  valence: Scalars['String']['input'];
};


export type RootMutationTypeExchangeRefreshForAccessTokenArgs = {
  refreshToken: Scalars['String']['input'];
};


export type RootMutationTypeParticipateInMosaicArgs = {
  mosaicId: Scalars['Int']['input'];
};


export type RootMutationTypeRegisterArgs = {
  email: Scalars['String']['input'];
};


export type RootMutationTypeRenewRefreshTokenArgs = {
  refreshToken: Scalars['String']['input'];
};

export type RootQueryType = {
  __typename?: 'RootQueryType';
  getFollowToken?: Maybe<Scalars['String']['output']>;
  getFollowers: Array<PublicUser>;
  getFollowing: Array<PublicUser>;
  listMoments: Array<Maybe<Moment>>;
  listMomentsForGraph: Array<MomentGraphItem>;
  listTextPosts: Array<TextPost>;
  listTransactions: Array<Maybe<Transaction>>;
  me: PrivateUser;
  unsafeCheckIfUserCanCheckIn?: Maybe<Scalars['Boolean']['output']>;
};

export type RootSubscriptionType = {
  __typename?: 'RootSubscriptionType';
  mosaicInstance?: Maybe<MosaicInstance>;
};

export type StickerType = {
  __typename?: 'StickerType';
  name?: Maybe<Scalars['String']['output']>;
  url?: Maybe<Scalars['String']['output']>;
};

export type TextPost = {
  __typename?: 'TextPost';
  body: Scalars['String']['output'];
  insertedAt: Scalars['String']['output'];
};

export type Transaction = {
  __typename?: 'Transaction';
  change?: Maybe<Scalars['Int']['output']>;
  stickerType?: Maybe<StickerType>;
};

export type WeeklyCheckIn = {
  __typename?: 'WeeklyCheckIn';
  weekNumber?: Maybe<Scalars['Int']['output']>;
  year?: Maybe<Scalars['Int']['output']>;
};

export type AddAvatarMutationVariables = Exact<{
  avatar: AvatarInput;
}>;


export type AddAvatarMutation = { __typename?: 'RootMutationType', addAvatar?: { __typename?: 'PublicUser', avatar?: { __typename?: 'Avatar', options?: string | null, style?: string | null } | null } | null };

export type ExchangeRefreshForAccessTokenMutationVariables = Exact<{
  refreshToken: Scalars['String']['input'];
}>;


export type ExchangeRefreshForAccessTokenMutation = { __typename?: 'RootMutationType', exchangeRefreshForAccessToken?: { __typename?: 'AuthBlob', token: string, claims: { __typename?: 'Claims', sub: string, exp: number, iat: number } } | null };

export type GetFollowTokenQueryVariables = Exact<{ [key: string]: never; }>;


export type GetFollowTokenQuery = { __typename?: 'RootQueryType', getFollowToken?: string | null };

export type GetFollowersAndFollowingQueryVariables = Exact<{ [key: string]: never; }>;


export type GetFollowersAndFollowingQuery = { __typename?: 'RootQueryType', getFollowers: Array<{ __typename?: 'PublicUser', username?: string | null, avatar?: { __typename?: 'Avatar', options?: string | null, style?: string | null } | null }>, getFollowing: Array<{ __typename?: 'PublicUser', username?: string | null, avatar?: { __typename?: 'Avatar', options?: string | null, style?: string | null } | null }> };

export type ListTextPostsQueryVariables = Exact<{ [key: string]: never; }>;


export type ListTextPostsQuery = { __typename?: 'RootQueryType', listTextPosts: Array<{ __typename?: 'TextPost', body: string, insertedAt: string }> };

export type ListMomentsForGraphQueryVariables = Exact<{ [key: string]: never; }>;


export type ListMomentsForGraphQuery = { __typename?: 'RootQueryType', listMomentsForGraph: Array<{ __typename?: 'MomentGraphItem', good?: number | null, bad?: number | null, insertedAt: string }> };

export type NewMosaicInstancesSubscriptionVariables = Exact<{ [key: string]: never; }>;


export type NewMosaicInstancesSubscription = { __typename?: 'RootSubscriptionType', mosaicInstance?: { __typename?: 'MosaicInstance', createdAt?: string | null, id?: number | null } | null };

export type CreateMomentMutationVariables = Exact<{
  type: MomentType;
}>;


export type CreateMomentMutation = { __typename?: 'RootMutationType', createMoment?: { __typename?: 'Moment', insertedAt: string, type: MomentType } | null };

export type CreateTextPostMutationVariables = Exact<{
  body: Scalars['String']['input'];
}>;


export type CreateTextPostMutation = { __typename?: 'RootMutationType', createTextPost?: { __typename?: 'TextPost', body: string } | null };

export type RegisterWithEmailMutationVariables = Exact<{
  email: Scalars['String']['input'];
}>;


export type RegisterWithEmailMutation = { __typename?: 'RootMutationType', register?: string | null };

export type RenewRefreshTokenMutationVariables = Exact<{
  refreshToken: Scalars['String']['input'];
}>;


export type RenewRefreshTokenMutation = { __typename?: 'RootMutationType', renewRefreshToken?: { __typename?: 'AuthBlob', token: string, claims: { __typename?: 'Claims', sub: string, exp: number, iat: number } } | null };

export type MyProfileQueryVariables = Exact<{ [key: string]: never; }>;

2
export type MyProfileQuery = { __typename?: 'RootQueryType', me: { __typename?: 'PrivateUser', email: string, public: { __typename?: 'PublicUser', username?: string | null, avatar?: { __typename?: 'Avatar', options?: string | null, style?: string | null } | null } } };

export type AddUsernameMutationVariables = Exact<{
  username: Scalars['String']['input'];
}>;


export type AddUsernameMutation = { __typename?: 'RootMutationType', addUsername?: { __typename?: 'PublicUser', username?: string | null } | null };


export const AddAvatarDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"mutation","name":{"kind":"Name","value":"addAvatar"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"avatar"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"AvatarInput"}}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"addAvatar"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"avatar"},"value":{"kind":"Variable","name":{"kind":"Name","value":"avatar"}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"avatar"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"options"}},{"kind":"Field","name":{"kind":"Name","value":"style"}}]}}]}}]}}]} as unknown as DocumentNode<AddAvatarMutation, AddAvatarMutationVariables>;
export const ExchangeRefreshForAccessTokenDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"mutation","name":{"kind":"Name","value":"exchangeRefreshForAccessToken"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"refreshToken"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"String"}}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"exchangeRefreshForAccessToken"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"refreshToken"},"value":{"kind":"Variable","name":{"kind":"Name","value":"refreshToken"}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"token"}},{"kind":"Field","name":{"kind":"Name","value":"claims"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"sub"}},{"kind":"Field","name":{"kind":"Name","value":"exp"}},{"kind":"Field","name":{"kind":"Name","value":"iat"}}]}}]}}]}}]} as unknown as DocumentNode<ExchangeRefreshForAccessTokenMutation, ExchangeRefreshForAccessTokenMutationVariables>;
export const GetFollowTokenDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"query","name":{"kind":"Name","value":"getFollowToken"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"getFollowToken"}}]}}]} as unknown as DocumentNode<GetFollowTokenQuery, GetFollowTokenQueryVariables>;
export const GetFollowersAndFollowingDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"query","name":{"kind":"Name","value":"getFollowersAndFollowing"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"getFollowers"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"avatar"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"options"}},{"kind":"Field","name":{"kind":"Name","value":"style"}}]}},{"kind":"Field","name":{"kind":"Name","value":"username"}}]}},{"kind":"Field","name":{"kind":"Name","value":"getFollowing"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"avatar"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"options"}},{"kind":"Field","name":{"kind":"Name","value":"style"}}]}},{"kind":"Field","name":{"kind":"Name","value":"username"}}]}}]}}]} as unknown as DocumentNode<GetFollowersAndFollowingQuery, GetFollowersAndFollowingQueryVariables>;
export const ListTextPostsDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"query","name":{"kind":"Name","value":"listTextPosts"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"listTextPosts"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"body"}},{"kind":"Field","name":{"kind":"Name","value":"insertedAt"}}]}}]}}]} as unknown as DocumentNode<ListTextPostsQuery, ListTextPostsQueryVariables>;
export const ListMomentsForGraphDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"query","name":{"kind":"Name","value":"listMomentsForGraph"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"listMomentsForGraph"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"good"}},{"kind":"Field","name":{"kind":"Name","value":"bad"}},{"kind":"Field","name":{"kind":"Name","value":"insertedAt"}}]}}]}}]} as unknown as DocumentNode<ListMomentsForGraphQuery, ListMomentsForGraphQueryVariables>;
export const NewMosaicInstancesDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"subscription","name":{"kind":"Name","value":"newMosaicInstances"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"mosaicInstance"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"createdAt"}},{"kind":"Field","name":{"kind":"Name","value":"id"}}]}}]}}]} as unknown as DocumentNode<NewMosaicInstancesSubscription, NewMosaicInstancesSubscriptionVariables>;
export const CreateMomentDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"mutation","name":{"kind":"Name","value":"createMoment"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"type"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"MomentType"}}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"createMoment"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"type"},"value":{"kind":"Variable","name":{"kind":"Name","value":"type"}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"insertedAt"}},{"kind":"Field","name":{"kind":"Name","value":"type"}}]}}]}}]} as unknown as DocumentNode<CreateMomentMutation, CreateMomentMutationVariables>;
export const CreateTextPostDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"mutation","name":{"kind":"Name","value":"createTextPost"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"body"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"String"}}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"createTextPost"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"body"},"value":{"kind":"Variable","name":{"kind":"Name","value":"body"}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"body"}}]}}]}}]} as unknown as DocumentNode<CreateTextPostMutation, CreateTextPostMutationVariables>;
export const RegisterWithEmailDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"mutation","name":{"kind":"Name","value":"registerWithEmail"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"email"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"String"}}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"register"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"email"},"value":{"kind":"Variable","name":{"kind":"Name","value":"email"}}}]}]}}]} as unknown as DocumentNode<RegisterWithEmailMutation, RegisterWithEmailMutationVariables>;
export const RenewRefreshTokenDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"mutation","name":{"kind":"Name","value":"renewRefreshToken"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"refreshToken"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"String"}}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"renewRefreshToken"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"refreshToken"},"value":{"kind":"Variable","name":{"kind":"Name","value":"refreshToken"}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"token"}},{"kind":"Field","name":{"kind":"Name","value":"claims"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"sub"}},{"kind":"Field","name":{"kind":"Name","value":"exp"}},{"kind":"Field","name":{"kind":"Name","value":"iat"}}]}}]}}]}}]} as unknown as DocumentNode<RenewRefreshTokenMutation, RenewRefreshTokenMutationVariables>;
export const MyProfileDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"query","name":{"kind":"Name","value":"myProfile"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"me"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"email"}},{"kind":"Field","name":{"kind":"Name","value":"public"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"avatar"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"options"}},{"kind":"Field","name":{"kind":"Name","value":"style"}}]}},{"kind":"Field","name":{"kind":"Name","value":"username"}}]}}]}}]}}]} as unknown as DocumentNode<MyProfileQuery, MyProfileQueryVariables>;
export const AddUsernameDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"mutation","name":{"kind":"Name","value":"addUsername"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"username"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"String"}}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"addUsername"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"username"},"value":{"kind":"Variable","name":{"kind":"Name","value":"username"}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"username"}}]}}]}}]} as unknown as DocumentNode<AddUsernameMutation, AddUsernameMutationVariables>;