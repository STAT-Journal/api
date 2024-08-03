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
  options?: InputMaybe<Scalars['String']['input']>;
  style?: InputMaybe<Scalars['String']['input']>;
};

export type Broadcast = {
  __typename?: 'Broadcast';
  id?: Maybe<Scalars['ID']['output']>;
  message?: Maybe<Scalars['String']['output']>;
};

export type Claims = {
  __typename?: 'Claims';
  exp: Scalars['Int']['output'];
  iat: Scalars['Int']['output'];
  sub: Scalars['String']['output'];
};

export type Follow = {
  __typename?: 'Follow';
  followee?: Maybe<PublicUser>;
  follower?: Maybe<PublicUser>;
};

export type Moment = {
  __typename?: 'Moment';
  insertedAt: Scalars['String']['output'];
  type: MomentType;
};

export enum MomentType {
  Bad = 'BAD',
  Good = 'GOOD'
}

export type Mosaic = {
  __typename?: 'Mosaic';
  createdAt?: Maybe<Scalars['Int']['output']>;
  endsAt?: Maybe<Scalars['Int']['output']>;
  id?: Maybe<Scalars['ID']['output']>;
  size?: Maybe<Scalars['Int']['output']>;
};

export type MosaicParticipation = {
  mosaicId?: InputMaybe<Scalars['ID']['input']>;
};

export type PrivateUser = {
  __typename?: 'PrivateUser';
  email?: Maybe<Scalars['String']['output']>;
  public?: Maybe<PublicUser>;
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
  createTextPost?: Maybe<TextPost>;
  createWeeklyCheckin?: Maybe<WeeklyCheckIn>;
  exchangeRefreshForAccessToken?: Maybe<AuthBlob>;
  participateInMosaic?: Maybe<Mosaic>;
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
  followedId: Scalars['ID']['input'];
};


export type RootMutationTypeCreateMomentArgs = {
  type: MomentType;
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
  mosaicParticipation: MosaicParticipation;
};


export type RootMutationTypeRegisterArgs = {
  email: Scalars['String']['input'];
};


export type RootMutationTypeRenewRefreshTokenArgs = {
  refreshToken: Scalars['String']['input'];
};

export type RootQueryType = {
  __typename?: 'RootQueryType';
  listMoments: Array<Maybe<Moment>>;
  listTextPosts: Array<TextPost>;
  listTransactions: Array<Maybe<Transaction>>;
  me?: Maybe<PrivateUser>;
  unsafeCheckIfUserCanCheckIn?: Maybe<Scalars['Boolean']['output']>;
};

export type RootSubscriptionType = {
  __typename?: 'RootSubscriptionType';
  broadcasts?: Maybe<Broadcast>;
  mosaicCircle?: Maybe<Mosaic>;
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

export type ListTextPostsQueryVariables = Exact<{ [key: string]: never; }>;


export type ListTextPostsQuery = { __typename?: 'RootQueryType', listTextPosts: Array<{ __typename?: 'TextPost', body: string, insertedAt: string }> };

export type ListMomentsQueryVariables = Exact<{ [key: string]: never; }>;


export type ListMomentsQuery = { __typename?: 'RootQueryType', listMoments: Array<{ __typename?: 'Moment', type: MomentType, insertedAt: string } | null> };

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


export type MyProfileQuery = { __typename?: 'RootQueryType', me?: { __typename?: 'PrivateUser', email?: string | null, public?: { __typename?: 'PublicUser', username?: string | null, avatar?: { __typename?: 'Avatar', options?: string | null, style?: string | null } | null } | null } | null };

export type AddUsernameMutationVariables = Exact<{
  username: Scalars['String']['input'];
}>;


export type AddUsernameMutation = { __typename?: 'RootMutationType', addUsername?: { __typename?: 'PublicUser', username?: string | null } | null };


export const AddAvatarDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"mutation","name":{"kind":"Name","value":"addAvatar"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"avatar"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"AvatarInput"}}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"addAvatar"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"avatar"},"value":{"kind":"Variable","name":{"kind":"Name","value":"avatar"}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"avatar"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"options"}},{"kind":"Field","name":{"kind":"Name","value":"style"}}]}}]}}]}}]} as unknown as DocumentNode<AddAvatarMutation, AddAvatarMutationVariables>;
export const ExchangeRefreshForAccessTokenDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"mutation","name":{"kind":"Name","value":"exchangeRefreshForAccessToken"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"refreshToken"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"String"}}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"exchangeRefreshForAccessToken"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"refreshToken"},"value":{"kind":"Variable","name":{"kind":"Name","value":"refreshToken"}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"token"}},{"kind":"Field","name":{"kind":"Name","value":"claims"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"sub"}},{"kind":"Field","name":{"kind":"Name","value":"exp"}},{"kind":"Field","name":{"kind":"Name","value":"iat"}}]}}]}}]}}]} as unknown as DocumentNode<ExchangeRefreshForAccessTokenMutation, ExchangeRefreshForAccessTokenMutationVariables>;
export const ListTextPostsDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"query","name":{"kind":"Name","value":"listTextPosts"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"listTextPosts"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"body"}},{"kind":"Field","name":{"kind":"Name","value":"insertedAt"}}]}}]}}]} as unknown as DocumentNode<ListTextPostsQuery, ListTextPostsQueryVariables>;
export const ListMomentsDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"query","name":{"kind":"Name","value":"listMoments"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"listMoments"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"type"}},{"kind":"Field","name":{"kind":"Name","value":"insertedAt"}}]}}]}}]} as unknown as DocumentNode<ListMomentsQuery, ListMomentsQueryVariables>;
export const CreateMomentDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"mutation","name":{"kind":"Name","value":"createMoment"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"type"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"MomentType"}}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"createMoment"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"type"},"value":{"kind":"Variable","name":{"kind":"Name","value":"type"}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"insertedAt"}},{"kind":"Field","name":{"kind":"Name","value":"type"}}]}}]}}]} as unknown as DocumentNode<CreateMomentMutation, CreateMomentMutationVariables>;
export const CreateTextPostDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"mutation","name":{"kind":"Name","value":"createTextPost"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"body"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"String"}}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"createTextPost"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"body"},"value":{"kind":"Variable","name":{"kind":"Name","value":"body"}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"body"}}]}}]}}]} as unknown as DocumentNode<CreateTextPostMutation, CreateTextPostMutationVariables>;
export const RegisterWithEmailDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"mutation","name":{"kind":"Name","value":"registerWithEmail"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"email"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"String"}}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"register"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"email"},"value":{"kind":"Variable","name":{"kind":"Name","value":"email"}}}]}]}}]} as unknown as DocumentNode<RegisterWithEmailMutation, RegisterWithEmailMutationVariables>;
export const RenewRefreshTokenDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"mutation","name":{"kind":"Name","value":"renewRefreshToken"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"refreshToken"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"String"}}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"renewRefreshToken"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"refreshToken"},"value":{"kind":"Variable","name":{"kind":"Name","value":"refreshToken"}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"token"}},{"kind":"Field","name":{"kind":"Name","value":"claims"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"sub"}},{"kind":"Field","name":{"kind":"Name","value":"exp"}},{"kind":"Field","name":{"kind":"Name","value":"iat"}}]}}]}}]}}]} as unknown as DocumentNode<RenewRefreshTokenMutation, RenewRefreshTokenMutationVariables>;
export const MyProfileDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"query","name":{"kind":"Name","value":"myProfile"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"me"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"email"}},{"kind":"Field","name":{"kind":"Name","value":"public"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"avatar"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"options"}},{"kind":"Field","name":{"kind":"Name","value":"style"}}]}},{"kind":"Field","name":{"kind":"Name","value":"username"}}]}}]}}]}}]} as unknown as DocumentNode<MyProfileQuery, MyProfileQueryVariables>;
export const AddUsernameDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"mutation","name":{"kind":"Name","value":"addUsername"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"username"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"String"}}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"addUsername"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"username"},"value":{"kind":"Variable","name":{"kind":"Name","value":"username"}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"username"}}]}}]}}]} as unknown as DocumentNode<AddUsernameMutation, AddUsernameMutationVariables>;